from flask import Flask, render_template_string, request, redirect, url_for
import psycopg

app = Flask(__name__)

# Funkcja łącząca się z bazą PostgreSQL
def get_connection():
    return psycopg.connect(
        host="pg_db",
        port=5432,
        user="admin",
        password="haslo123",
        dbname="base",
        connect_timeout=5
    )

# Strona główna – lista użytkowników
@app.route("/")
def show_users():
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id, username, email FROM users ORDER BY id")
                rows = cur.fetchall()

        if not rows:
            return "<h3>Brak użytkowników w bazie.</h3><a href='/add'>Dodaj użytkownika</a>"

        html = """
        <h2>Users</h2>
        <a href="/add">➕ Dodaj nowego użytkownika</a><br><br>
        <table border="1" cellpadding="5">
            <tr><th>ID</th><th>Username</th><th>Email</th></tr>
            {% for user in users %}
            <tr>
                <td>{{ user[0] }}</td>
                <td>{{ user[1] }}</td>
                <td>{{ user[2] }}</td>
            </tr>
            {% endfor %}
        </table>
        """
        return render_template_string(html, users=rows)

    except Exception as e:
        return f"<h3>❌ Błąd połączenia z bazą: {e}</h3>"

# Strona dodawania użytkownika
@app.route("/add", methods=["GET", "POST"])
def add_user():
    if request.method == "POST":
        username = request.form.get("username")
        email = request.form.get("email")
        password = request.form.get("password_hash")

        if not username or not email:
            return "<h3>❌ Wszystkie pola są wymagane!</h3><a href='/add'>Spróbuj ponownie</a>"

        try:
            with get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        "INSERT INTO users (username, email, password_hash) VALUES (%s, %s, %s)",
                        (username, email, password)
                    )
                    conn.commit()
            # Po dodaniu przekierowujemy na stronę główną
            return redirect(url_for('show_users'))

        except Exception as e:
            return f"<h3>❌ Błąd dodawania użytkownika: {e}</h3><a href='/add'>Spróbuj ponownie</a>"

    # Jeśli GET, pokazujemy formularz
    html_form = """
    <h2>Dodaj użytkownika</h2>
    <form method="post">
        <label>Username: <input type="text" name="username"></label><br><br>
        <label>Email: <input type="email" name="email"></label><br><br>
        <label>Haslo: <input type="password" name="password_hash"></label><br><br>
        <input type="submit" value="Dodaj">
    </form>
    <a href="/">Powrót do listy użytkowników</a>
    """
    return render_template_string(html_form)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
