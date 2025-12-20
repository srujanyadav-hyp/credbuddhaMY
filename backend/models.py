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

         def to_dict(self):
                 return {
                         "id":self.id,
                         "phone":self.phone,
                         "created_at":self.created_at.isoformat()
                 }
