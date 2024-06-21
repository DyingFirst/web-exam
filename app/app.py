from flask import Flask, render_template, request, redirect, url_for, flash, make_response
from flask_login import LoginManager, login_user, logout_user, login_required, current_user
from flask_paginate import Pagination, get_page_parameter
import markdown2
from mysql_db import MySQL
import sql_queris
import usecase
from config import readconfig
from auth import permission_check, User, init_login_manager
from flaskext.markdown import Markdown
import bleach
import csv
from io import StringIO
import datetime

app = Flask(__name__)
Markdown(app)

cfg = readconfig()
app.config['SECRET_KEY'] = cfg['key']
db = MySQL(cfg)

app.config['ADMIN_ROLE_ID'] = usecase.getRoleIDByName(db, "administrator")
app.config['MODER_ROLE_ID'] = usecase.getRoleIDByName(db, "moderator")

login_manager = LoginManager()
login_manager.init_app(app)

login_manager.login_view = 'login'
login_manager.login_message = 'Для доступа к этой странице нужно авторизироваться.'
login_manager.login_message_category = 'warning'

UPLOAD_FOLDER = './static'

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER



init_login_manager(app, db)


@app.route('/')
def index():
    page = request.args.get('page', type=int)
    if not page:
        page = 1
    elif page < 1:
        return redirect(url_for('index', page=1))

    books_list, pages_count = usecase.load_books(db, int(page))

    genres = usecase.load_genres(db)
    years = usecase.load_years(db)

    print(books_list)

    return render_template('index.html', books=books_list, pages_count=pages_count, genres=genres, years=years)


@app.before_request
def loger():
    path = request.path
    if request.endpoint == "static":
        return
    user_id = getattr(current_user, "id", None)
    cursor = db.connection().cursor(named_tuple=True)
    query = """INSERT INTO visit_logs (path, user_id) VALUES(%s, %s)"""
    cursor.execute(query, (path, user_id))
    db.connection().commit()
    cursor.close()


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        login = request.form['login']
        password = request.form['password']
        remember = request.form.get('remember_me') == 'on'

        with db.connection().cursor(named_tuple=True) as cursor:
            cursor.execute(sql_queris.queryCheckCorrectnessLoginAndPassword, (login, password))
            print(cursor.statement)
            user = cursor.fetchone()

        if user:
            login_user(User(user.id, user.login, user.role_id, user.first_name, user.last_name, user.middle_name),
                       remember=remember)
            flash('Вы успешно прошли аутентификацию!', 'success')
            param_url = request.args.get('next')
            return redirect(param_url or url_for('index'))

        flash('Невозможно аутентифицироваться с указанными логином и паролем', 'danger')
    return render_template('login.html')


@app.route('/logout', methods=['GET'])
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/books/add', methods=['POST', 'GET'])
@login_required
@permission_check('create', db)
def add_book():
    if request.method == 'GET':
        return render_template('create.html', genres=usecase.load_genres(db))

    file = request.files['book_cover']

    title = request.form['title']
    short_decryption = bleach.clean(request.form['short_description'])
    year = request.form['year']
    publisher = request.form['publisher']
    author = request.form['author']
    page_count = request.form['page_count']
    genres_id = request.form.getlist('genres_id')

    is_insert = usecase.add_book(
        file, title, short_decryption,
        year, publisher, author, page_count,
        genres_id, db, app.config['UPLOAD_FOLDER']
    )
    if is_insert:
        flash('Вы успешно добавили книгу!', 'success')
    else:
        flash('Что-то пошло не так, повторите попытку позже', 'danger')

    return redirect(url_for('index'))


@app.route('/books/delete/<int:book_id>', methods=['POST'])
@login_required
@permission_check('delete', db)
def delete_book(book_id):
    is_delete = usecase.delete_book_by_id(book_id, db, app.config['UPLOAD_FOLDER'])
    if is_delete:
        flash('Вы успешно удалили книгу!', 'success')
    else:
        flash('Что-то пошло не так, повторите попытку позже', 'success')

    return redirect(url_for('index'))


@app.route('/books/edit/<int:book_id>', methods=['POST', 'GET'])
@login_required
@permission_check('edit', db)
def edit_book(book_id):
    if request.method == 'GET':
        book = usecase.load_book(db, book_id)[0]
        descriptionHTML = markdown2.markdown(book.short_description)
        genres = usecase.load_genres(db)
        return render_template('edit.html', genres=genres, description=descriptionHTML, book=book)

    title = request.form['title']
    short_decryption = bleach.clean(request.form['short_description'])
    year = request.form['year']
    publisher = request.form['publisher']
    author = request.form['author']
    page_count = request.form['page_count']
    genres_id = request.form.getlist('genres_id')

    is_update = usecase.update_book(db, title, short_decryption, year, publisher, author, page_count, book_id,
                                    genres_id)
    if is_update:
        flash('Вы успешно отредактировали книгу!', 'success')
    else:
        flash('Что-то пошло не так, повторите попытку позже', 'danger')

    return redirect(url_for('index'))


@app.route('/books/view/<int:book_id>', methods=['GET'])
def view_book(book_id):
    book = usecase.load_book(db, book_id)[0]
    descriptionHTML = markdown2.markdown(book.short_description)
    reviews = usecase.load_reviews(db, book_id)
    if current_user and current_user.is_authenticated:
        been_reviewed = usecase.is_rew(book_id, current_user.id, db)
        usecase.update_view_count(db, book_id, current_user.id)
    else:
        been_reviewed = False
    return render_template('book.html', book=book, description=descriptionHTML, reviews=reviews,
                           been_reviewed=been_reviewed)


@app.route('/books/review/<int:book_id>', methods=['POST', 'GET'])
@login_required
@permission_check('review', db)
def review_book(book_id):
    user_id = getattr(current_user, 'id', None)
    if request.method == 'GET':
        scores = {
            5: "отлично",
            4: "хорошо",
            3: "удовлетворительно",
            2: "неудовлетворительно",
            1: "плохо",
            0: "ужасно",
        }
        return render_template("feedback.html", scores=scores)

    rating = request.form['rating']
    text = bleach.clean(request.form['text'])

    is_update = usecase.set_rew(db, book_id, user_id, rating, text)
    if is_update:
        flash('Вы успешно добавили рецензию!', 'success')
    else:
        flash('Что-то пошло не так, повторите попытку позже', 'danger')

    return redirect(url_for('view_book', book_id=book_id))


@app.route('/books/most_popular', methods=['POST', 'GET'])
def most_popular():
    books = usecase.most_popular(db)
    genres = usecase.load_genres(db)
    years = usecase.load_years(db)
    return render_template('index.html', books=books, pages_count=1, genres=genres, years=years)


@app.route('/books/last_viewed', methods=['POST', 'GET'])
def last_viewed():
    if current_user.is_authenticated:
        books = usecase.get_recently_viewed_books(db, current_user.id)
        genres = usecase.load_genres(db)
        years = usecase.load_years(db)
        return render_template('index.html', books=books, pages_count=1, genres=genres, years=years)
    else:
        return redirect(url_for('login'))


@app.route('/stats')
@login_required
@permission_check('create', db)
def stats():
    page = request.args.get(get_page_parameter(), type=int, default=1)
    per_page = 10
    offset = (page - 1) * per_page

    date_from = request.args.get('date_from')
    date_to = request.args.get('date_to')

    logs, total_logs = usecase.load_user_activity_log(db, per_page, offset)
    view_stats, total_views = usecase.load_view_stats(db, per_page, offset, date_from, date_to)

    user_log_pagination = Pagination(page=page, total=total_logs, per_page=per_page, css_framework='bootstrap4')
    book_stats_pagination = Pagination(page=page, total=total_views, per_page=per_page, css_framework='bootstrap4')

    return render_template('statistics.html', logs=logs, view_stats=view_stats,
                           user_log_pagination=user_log_pagination, book_stats_pagination=book_stats_pagination,
                           request=request)


@app.route('/export_user_log_csv')
@login_required
@permission_check('create', db)
def export_user_log_csv():
    logs = usecase.load_user_activity_log_csv(db)

    si = StringIO()
    cw = csv.writer(si)
    cw.writerow(['№', 'ФИО пользователя', 'Название просмотренной книги', 'Дата и время просмотра'])
    for idx, log in enumerate(logs, start=1):
        fio = f"{log.last_name} {log.first_name} {log.middle_name}" if log.first_name else "Неаутентифицированный пользователь"
        cw.writerow([idx, fio, log.title, log.created_at])

    filename = f"user_log_{datetime.datetime.now().strftime('%Y-%m-%d')}.csv"
    output = make_response(si.getvalue())
    output.headers["Content-Disposition"] = f"attachment; filename={filename}"
    output.headers["Content-type"] = "text/csv"

    return output


@app.route('/export_view_stats_csv')
@login_required
@permission_check('create', db)
def export_view_stats_csv():
    view_stats = usecase.load_view_stats_csv(db)

    si = StringIO()
    cw = csv.writer(si)
    cw.writerow(['№', 'Название книги', 'Количество просмотров'])
    for idx, stat in enumerate(view_stats, start=1):
        cw.writerow([idx, stat.title, stat.view_count])

    filename = f"view_stats_{datetime.datetime.now().strftime('%Y-%m-%d')}.csv"
    output = make_response(si.getvalue())
    output.headers["Content-Disposition"] = f"attachment; filename={filename}"
    output.headers["Content-type"] = "text/csv"
    return output


if __name__ == '__main__':
    app.run(debug=True)
