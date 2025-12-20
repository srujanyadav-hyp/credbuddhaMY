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
    user.otp_code=otp
    user.otp_expiry=datetime.now()+ timedelta(minutes=3)
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
@auth_bp.route('/verify-otp', methods=['POST'])
def verify_otp():
    data = request.json
    phone = data.get('phone')
    otp_input = data.get('otp')

    if not phone or not otp_input:
        return jsonify({'error': "Phone and OTP are required"}), 400

    # 1. Find the user
    user = Users.query.filter_by(phone=phone).first()

    if not user:
        return jsonify({'error': "User not found"}), 404

    # 2. Check if OTP matches
    if user.otp_code != otp_input:
        return jsonify({'error': "Invalid OTP"}), 400

    # 3. Check if OTP is expired
    if datetime.now() > user.otp_expiry:
        return jsonify({'error': "OTP Expired"}), 400

    # 4. Success! (Clear the OTP so it can't be reused)
    user.otp_code = None
    db.session.commit()

    # 5. Generate a "Session Token" (For now, we fake it, later we use JWT)
    # We return the user data so Flutter can save it.
    return jsonify({
        'message': "Login Successful",
        'token': f"session_{user.id}_{random.randint(1000,9999)}", # Fake token for now
        'user': user.to_dict()
    }), 200

