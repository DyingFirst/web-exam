from werkzeug.utils import secure_filename
from datetime import datetime, timedelta
import sql_queris
import mysql.connector
import uuid
import hashlib
import os
import math

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}


def load_years(db):
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)
        cursor.execute(sql_queris.queryGetAllYears, ())
        years = cursor.fetchall()
        cursor.close()
        return years

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        return []


def load_reviews(db, book_id):
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)
        cursor.execute(sql_queris.queryGetBookReviews, (book_id,))
        reviews = cursor.fetchall()
        cursor.close()
        return reviews

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        raise err
        return []


def load_books(db, page):
    db_conn = db.connection()
    books_per_page = 10
    try:
        offset = (page - 1) * books_per_page

        cursor = db_conn.cursor(named_tuple=True)
        cursor.execute(sql_queris.queryGetBatchBook, (offset,))
        books = cursor.fetchall()
        cursor.close()

        books_count = math.ceil(len(books) / 10)

        return books, books_count

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return [], 0


def load_genres(db):
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)
        cursor.execute(sql_queris.queryGetAllGenres)
        genres = cursor.fetchall()
        cursor.close()

        return genres

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return []


def load_book(db, book_id):
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)
        cursor.execute(sql_queris.queryGetBookByID, (book_id,))
        book = cursor.fetchall()
        cursor.close()

        return book

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return []


def add_book(file, title, short_decryption, year, publisher, author, page_count, genres_ids, db, save_path) -> bool:
    # сетим в books_covers
    # сетим в books
    # сетим в books_genres
    db_conn = db.connection()

    file.name = uuid.uuid4()
    if _allowed_file(file.filename):
        try:
            md5_hash = hashlib.md5()
            for batch in iter(lambda: file.stream.read(4096), b""):
                md5_hash.update(batch)
            file.stream.seek(0)

            filename = secure_filename(file.filename)
            hex_hash = md5_hash.hexdigest()
            mime_type = file.mimetype

            cursor = db_conn.cursor(named_tuple=True)
            cursor.execute(sql_queris.queryGetCoverIDAndFileNameByHash, (hex_hash,))

            existing_record = cursor.fetchone()
            if not existing_record:
                try:
                    if not os.path.exists(save_path):
                        os.makedirs(save_path)
                    file.save(os.path.join(save_path, filename))
                except Exception as e:
                    raise e
                    return False

                cursor.execute(sql_queris.querySetCover, (filename, mime_type, hex_hash))
                db_conn.commit()

                cursor.execute(sql_queris.queryGetCoverIDAndFileNameByHash, (hex_hash,))
                cover_record = cursor.fetchone()
            else:
                cover_record = existing_record

            print(cover_record)

            cursor.execute(
                sql_queris.querySetBooks,
                (title, short_decryption, year, publisher, author, page_count, cover_record[0])
            )
            db_conn.commit()

            cursor.execute(sql_queris.queryGetLastBookID)
            last_book_id = cursor.fetchone()[0]

            for genres_id in genres_ids:
                cursor.execute(sql_queris.querySetBookIDAndGenresID, (last_book_id, genres_id))
                db_conn.commit()

            cursor.close()

        except mysql.connector.Error as err:
            print("Something went wrong: {}".format(err))
            db_conn.rollback()
            return False
    else:
        return False

    return True


def _allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def delete_book_by_id(book_id, db, save_path) -> bool:
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)

        cursor.execute(sql_queris.queryGetCoverIDByBookID, (book_id,))
        cover_id = cursor.fetchone()[0]

        cursor.execute(sql_queris.queryGetCoverFileName, (cover_id,))
        cover_file_name = cursor.fetchone()[0]

        cursor.execute(sql_queris.queryGetBooksByCoverID, (cover_id,))
        books = cursor.fetchall()

        cursor.execute(sql_queris.queryDeleteFromBookGenres, (book_id,))
        db_conn.commit()

        cursor.execute(sql_queris.queryDeleteFromReviews, (book_id,))
        db_conn.commit()

        cursor.execute(sql_queris.queryDeleteBookByID, (book_id,))
        db_conn.commit()

        print(len(books))
        if len(books) <= 1:
            cursor.execute(sql_queris.queryDeleteFromBookCoversByCoverID, (cover_id,))
            db_conn.commit()

        cursor.close()

        if len(books) <= 1 and os.path.exists(f"{save_path}/{cover_file_name}"):
            os.remove(f"{save_path}/{cover_file_name}")

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return False

    return True


def update_book(db, title, short_decryption, year, publisher, author, page_count, book_id, genres_ids) -> bool:
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)

        # update book info
        cursor.execute(
            sql_queris.queryUpdateBookByID,
            (title, short_decryption, year, publisher, author, page_count, book_id)
        )
        db_conn.commit()

        # delete genres
        cursor.execute(
            sql_queris.queryDeleteFromBookGenres,
            (book_id,)
        )
        db_conn.commit()

        for genres_id in genres_ids:
            cursor.execute(
                sql_queris.querySetBookIDAndGenresID,
                (book_id, genres_id)
            )
            db_conn.commit()

        cursor.close()

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return False

    return True


def is_rew(book_id, user_id, db):
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)

        cursor.execute(sql_queris.queryGetRewText, (user_id, book_id))
        text = cursor.fetchone()

        cursor.close()

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return []

    return text


def set_rew(db, book_id, user_id, rating, text):
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)

        print(user_id, book_id, rating, text)
        cursor.execute(sql_queris.querySetRew, (book_id, user_id, rating, text))
        db_conn.commit()

        cursor.close()

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return False

    return True


def get_recently_viewed_books(db, user_id):
    db_conn = db.connection()
    try:
        cursor = db_conn.cursor(named_tuple=True)

        cursor.execute(sql_queris.queryGetLastViews, user_id)
        books = cursor.fetchall()
        db_conn.commit()

        cursor.close()

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return None

    return books


def update_view_count(db, book_id, user_id):
    db_conn = db.connection()
    now = datetime.now()
    start_of_day = now.replace(hour=0, minute=0, second=0, microsecond=0)
    try:
        cursor = db_conn.cursor(named_tuple=True)

        cursor.execute(sql_queris.queryUpdateLastViews, (user_id, book_id, now, user_id, book_id, start_of_day))
        db_conn.commit()

        cursor.close()

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return False

    return True


def most_popular(db):
    db_conn = db.connection()
    three_months_ago = datetime.now() - timedelta(days=90)

    try:
        cursor = db_conn.cursor(named_tuple=True)

        cursor.execute(sql_queris.queryMostPopular, (three_months_ago,))
        books = cursor.fetchall()
        db_conn.commit()

        cursor.close()

    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        db_conn.rollback()
        return None

    return books

