from flask import Flask
from extension import db
from routes.auth import auth_bp
from routes.profile import profile_bp
def create_app():
    # 1. Initialize Flask App (Node: const app = express())
    app = Flask(__name__)

    # 2. Configuration
    # Where is the DB? 'sqlite:///...' creates a file named credbuddha.db
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///credbuddha.db'
    
    # Stop annoying warnings
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    # 3. Connect DB to App
    db.init_app(app)

    # 4. Register Routes (Node: app.use('/api/auth', authRoutes))
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(profile_bp, url_prefix='/api/profile')
    # 5. Create Tables (Dev Mode Only)
    # This automatically looks at models.py and creates tables if they don't exist.
    with app.app_context():
        db.create_all()

    return app

if __name__ == '__main__':
    app = create_app()
    # 6. Run Server (Node: app.listen(5000))
    # host='0.0.0.0' allows external access (like from Android Emulator)
    app.run(host='0.0.0.0', port=5000, debug=True)