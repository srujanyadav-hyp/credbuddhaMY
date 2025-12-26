from flask import Blueprint, request, jsonify
from models import Users, UserProfile
from extension import db

profile_bp = Blueprint('profile', __name__)

# --- 1. UPDATE PROFILE (POST) ---
@profile_bp.route('/update', methods=['POST'])
def update_profile():
    # Use silent=True so it doesn't crash if body is empty
    data = request.get_json(silent=True)
    
    if not data:
        return jsonify({'error': "No data provided"}), 400
    
    user_id = data.get('user_id')
    
    if not user_id:
        return jsonify({'error': "User ID is required"}), 400
        
    # Find User
    user = Users.query.get(user_id)
    if not user:
        return jsonify({'error': "User not found"}), 404

    # Find or Create Profile
    profile = UserProfile.query.filter_by(user_id=user_id).first()
    
    if not profile:
        profile = UserProfile(user_id=user_id)
        db.session.add(profile)
    
    # Update Fields (Check individually)
    if 'full_name' in data: profile.full_name = data['full_name']
    if 'email' in data: profile.email = data['email']
    if 'gender' in data: profile.gender = data['gender']
    if 'employment_type' in data: profile.employment_type = data['employment_type']
    if 'monthly_income' in data: profile.monthly_income = data['monthly_income']
    if 'pan_number' in data: profile.pan_number = data['pan_number']
    if 'dob' in data: profile.dob = data['dob']
    if 'address' in data: profile.address = data['address']
    if 'city' in data: profile.city = data['city']
    if 'state' in data: profile.state = data['state']
    if 'pincode' in data: profile.pincode = data['pincode']

    # Save to DB
    try:
        db.session.commit()
        return jsonify({
            'message': "Profile Updated Successfully", 
            'profile': profile.to_dict()
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': f"Database Error: {str(e)}"}), 500


# --- 2. GET PROFILE (GET) ---
@profile_bp.route('/get', methods=['GET'])
def get_profile():
    user_id = request.args.get('user_id')
    
    if not user_id:
        return jsonify({'error': "User ID is required"}), 400
        
    profile = UserProfile.query.filter_by(user_id=user_id).first()
    
    if not profile:
        return jsonify({'error': "Profile not found"}), 404

    return jsonify(profile.to_dict()), 200