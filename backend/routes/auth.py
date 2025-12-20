from flask import Blueprint, request, jsonify
from extension import db
from models import Users
import random
from datetime import datetime, timedelta

auth_bp=Blueprint('auth',__name__)

@auth_bp.route('/send-otp',methods=['POST'])
def send_otp():
    data= request.json
    phone=data.get('phone')
    if not phone or len(phone)!=10:
        return jsonify({'error':"Invalid phone number"}), 400
    otp=str(random.randint(100000,999999))
    user=Users.query.filter_by(phone=phone).first()
    if not user:
        user=Users(phone=phone)
        db.session.add(user) #THIS DATA IN THE STAGE
    Users.otp_code=otp
    Users.otp_expiry=datetime.now()+ timedelta(minutes=3)
    db.session.commit() #THIS DATA ADDING IS SUCCESSFULLY COMMITED

    print(f'debug otp: {otp}')
    return jsonify({'message':"otp send successfully",'otp': otp,'user':Users.to_dict(user)}),200
@auth_bp.route('/users',methods=['GET'])
def get_users():
    users=Users.query.all()
    # List Comprehension (Python's short loop syntax)
    result = [user.to_dict() for user in users]

    # 3. RETURN: Send the list of dictionaries as JSON
    return jsonify(result), 200


