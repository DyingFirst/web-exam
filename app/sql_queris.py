queryCheckCorrectnessLoginAndPassword = 'SELECT * FROM users WHERE login = %s and password_hash = SHA2(%s, 256);'

queryGetUserByID = 'SELECT * FROM users WHERE users.id = %s;'

queryGetBatchBook = """
        SELECT
            b.id,
            b.title,
            b.author,
            GROUP_CONCAT(g.name ORDER BY g.name ASC) as genres,
            b.year,
            COALESCE(ROUND(AVG(r.rating), 1), 0) as average_rating,
            COALESCE(rc.reviews_count, 0) as reviews_count,
            bc.file_name
        FROM
            books b
        LEFT JOIN book_genres bg ON b.id = bg.book_id
        LEFT JOIN genres g ON bg.genre_id = g.id
        LEFT JOIN reviews r ON b.id = r.book_id
        LEFT JOIN book_covers bc ON b.cover_id = bc.id
        LEFT JOIN (
            SELECT
                book_id,
                COUNT(id) as reviews_count
            FROM
                reviews
            GROUP BY
                book_id
        ) rc ON b.id = rc.book_id
        GROUP BY
            b.id
        ORDER BY
            b.year DESC
        LIMIT 10 OFFSET %s;
        """

queryGetAllGenres = "SELECT * FROM genres"

# region setBook
queryGetCoverIDAndFileNameByHash = "SELECT id, file_name FROM book_covers WHERE md5_hash = %s;"

querySetCover = "INSERT INTO book_covers (file_name, mime_type, md5_hash) VALUES (%s, %s, %s);"

querySetBooks = """
INSERT INTO books (title, short_description, year, publisher, author, page_count, cover_id)
VALUES (%s, %s, %s, %s, %s, %s, %s);"""

queryGetLastBookID = "SELECT LAST_INSERT_ID() AS id;"

querySetBookIDAndGenresID = "INSERT INTO book_genres (book_id, genre_id) VALUES (%s, %s);"

# endregion
# region deleteBook

queryGetCoverIDByBookID = "SELECT cover_id FROM books WHERE id = %s"

queryGetCoverFileName = "SELECT file_name FROM book_covers WHERE id = %s;"

queryGetBooksByCoverID = "SELECT id FROM books WHERE cover_id = %s"

queryDeleteBookByID = "DELETE FROM books WHERE id = %s;"

queryDeleteFromBookGenres = "DELETE FROM book_genres WHERE book_id = %s;"

queryDeleteFromBookCoversByCoverID = "DELETE FROM book_covers WHERE id = %s;"

queryDeleteFromReviews = "DELETE FROM reviews WHERE book_id = %s;"

# endregion

queryGetBookByID = """
        SELECT b.*, GROUP_CONCAT(genres.name ORDER BY genres.name ASC) as genres, book_covers.file_name
        FROM books AS b
        LEFT JOIN book_genres ON b.id = book_genres.book_id
        LEFT JOIN genres ON book_genres.genre_id = genres.id
        LEFT JOIN book_covers ON b.cover_id = book_covers.id
        WHERE b.id = %s
        """

queryUpdateBookByID = """
        UPDATE books
        SET 
            title = %s,
            short_description = %s,
            year = %s,
            publisher = %s,
            author = %s,
            page_count = %s
        WHERE id = %s;
        """

queryUpdateGenres = """
        UPDATE book_genres
        SET 
            genre_id = %s
        WHERE book_id = %s;
        """

queryGetRewText = """
        SELECT text
        FROM reviews
        WHERE user_id = %s
        AND book_id = %s
        """

querySetRew = """
        INSERT INTO reviews (book_id, user_id, rating, text, created_at) VALUES (%s, %s, %s, %s, CURRENT_TIMESTAMP);
        """

queryGetAllYears = "SELECT DISTINCT year FROM books ORDER BY year"

queryGetBookReviews = """
        SELECT r.*, u.first_name AS user_name, u.last_name AS user_last_name
        FROM reviews AS r
        LEFT JOIN users AS u ON r.user_id = u.id
        WHERE r.book_id = %s
        """

queryGetLastViews = """
                SELECT 
            b.id,
            b.title,
            b.year,
            bc.file_name,
            v.view_date
        FROM 
            views v
        JOIN 
            books b ON v.book_id = b.id
        LEFT JOIN 
            book_covers bc ON b.cover_id = bc.id
        WHERE 
            v.user_id = %s
        ORDER BY 
            v.view_date DESC
        LIMIT 5
        """

queryUpdateLastViews = """
        INSERT INTO views (user_id, book_id, view_date)
        SELECT %s, %s, %s
        WHERE NOT EXISTS (
            SELECT 1 FROM views 
            WHERE user_id = %s AND book_id = %s 
            AND view_date >= %s
        )
        """

queryMostPopular = """
                WITH popular_books AS (
            SELECT 
                books.id AS book_id, 
                COUNT(views.id) AS view_count
            FROM 
                books
            JOIN 
                views ON books.id = views.book_id
            WHERE 
                views.view_date >= %s
            GROUP BY 
                books.id
            ORDER BY 
                view_count DESC
            LIMIT 5
        )
        SELECT
            b.id,
            b.title,
            GROUP_CONCAT(g.name ORDER BY g.name ASC) as genres,
            b.year,
            COALESCE(ROUND(AVG(r.rating), 1), 0) as average_rating,
            COALESCE(rc.reviews_count, 0) as reviews_count,
            bc.file_name
        FROM
            books b
        LEFT JOIN 
            book_genres bg ON b.id = bg.book_id
        LEFT JOIN 
            genres g ON bg.genre_id = g.id
        LEFT JOIN 
            reviews r ON b.id = r.book_id
        LEFT JOIN 
            book_covers bc ON b.cover_id = bc.id
        LEFT JOIN (
            SELECT
                book_id,
                COUNT(id) as reviews_count
            FROM
                reviews
            GROUP BY
                book_id
        ) rc ON b.id = rc.book_id
        WHERE 
            b.id IN (SELECT book_id FROM popular_books)
        GROUP BY
            b.id
        ORDER BY
            b.year DESC
        LIMIT 5
        """

queryLoadUserActiveUser = """
        SELECT 
            COALESCE(u.last_name, '') AS last_name,
            COALESCE(u.first_name, '') AS first_name,
            COALESCE(u.middle_name, '') AS middle_name,
            b.title,
            v.created_at
        FROM 
            visit_logs v
        LEFT JOIN 
            users u ON v.user_id = u.id
        JOIN 
            books b ON SUBSTRING_INDEX(SUBSTRING_INDEX(v.path, '/', -1), '}', 1) = b.id
        WHERE 
            v.path LIKE '/books/view/%'
        ORDER BY 
            v.created_at DESC
        LIMIT %s OFFSET %s
        """

queryGetCountActiveUser = """
        SELECT 
            COUNT(*) AS view_count
        FROM 
            visit_logs v
        JOIN 
            books b ON SUBSTRING_INDEX(SUBSTRING_INDEX(v.path, '/', -1), '}', 1) = b.id
        WHERE 
            v.path LIKE '/books/view/%'
        """

queryGetCountStatsView = """
        SELECT COUNT(DISTINCT b.id) AS view_count 
        FROM views v 
        JOIN books b ON v.book_id = b.id 
        WHERE v.user_id IS NOT NULL
        """

queryLoadUserActiveUserCSV = """
        SELECT 
            COALESCE(u.last_name, '') AS last_name, 
            COALESCE(u.first_name, '') AS first_name, 
            COALESCE(u.middle_name, '') AS middle_name, 
            b.title, 
            v.created_at 
        FROM 
            visit_logs v
        LEFT JOIN 
            users u ON v.user_id = u.id
        JOIN 
            books b ON SUBSTRING_INDEX(SUBSTRING_INDEX(v.path, '/', -1), '}', 1) = b.id
        WHERE 
            v.path LIKE '/books/view/%'
        ORDER BY 
            v.created_at DESC
        """

queryLoadStatsView = """
        SELECT 
            b.title, 
            COUNT(v.id) AS view_count 
        FROM 
            views v
        JOIN 
            books b ON v.book_id = b.id
        WHERE 
            v.user_id IS NOT NULL
        GROUP BY b.id ORDER BY view_count DESC
        """

queryGetRoleIDByName = """SELECT id FROM roles WHERE name = %s;"""