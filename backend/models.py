from extension import db # improt the database
from datetime import datetime # datetime use library

# table creation (class=table)
class Users(db.Model):
         #table name
         __tablename__='users'

         id=db.Column(db.Integer, primary_key=True)
         phone=db.Column(db.String(15), unique=True, nullable=False)
         created_at=db.Column(db.DateTime,default=datetime.now)

         otp_code=db.Column(db.String(6), nullable=True)
         otp_expiry=db.Column(db.DateTime, nullable=True)
         profile = db.relationship('UserProfile', backref='user', uselist=False)

         def to_dict(self):
                 return {
                         "id":self.id,
                         "phone":self.phone,
                         "created_at":self.created_at.isoformat(),
                         "profile_complete": True if self.profile else False
                 }
         
 # Users profile table        
class UserProfile(db.Model):
    __tablename__ = 'user_profiles'

    id = db.Column(db.Integer, primary_key=True)
    
    # ForeignKey: Links this profile to a specific User ID
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    
    # Basic Details
    full_name = db.Column(db.String(100), nullable=True)
    email = db.Column(db.String(120), nullable=True)
    gender = db.Column(db.String(10), nullable=True) # "Male", "Female"
    
    # Employment Details
    employment_type = db.Column(db.String(50), nullable=True) # "Salaried", "Self-Employed"
    monthly_income = db.Column(db.Float, nullable=True)
    company_name = db.Column(db.String(100), nullable=True)
    
    # Identity & Location
    pan_number = db.Column(db.String(10), nullable=True)
    dob = db.Column(db.String(20), nullable=True) 
    pincode = db.Column(db.String(6), nullable=True)
    city = db.Column(db.String(50), nullable=True)

    def to_dict(self):
        return {
            "full_name": self.full_name,
            "email": self.email,
            "gender": self.gender,
            "employment_type": self.employment_type,
            "monthly_income": self.monthly_income,
            "pan_number": self.pan_number,
            "is_complete": bool(self.pan_number and self.monthly_income) 
        }