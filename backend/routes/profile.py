from flask import Blueprint, request, jsonify
from extension import db
from models import Users, UserProfile

profile_bp = Blueprint('profile', __name__)

@profile_bp.route('/update', methods=['POST'])
def update_profile():
    data = request.json
    
    # We need the user_id to know WHOSE profile this is.
    # In a real app, we get this from the "Token". 
    # For now, we will send user_id from the Flutter App.
    user_id = data.get('user_id')
    
    if not user_id:
        return jsonify({'error': "User ID is required"}), 400
        
    # 1. Find the User
    user = Users.query.get(user_id)
    if not user:
        return jsonify({'error': "User not found"}), 404

    # 2. Check if Profile already exists
    profile = UserProfile.query.filter_by(user_id=user_id).first()
    
    if not profile:
        # Create New Profile
        profile = UserProfile(user_id=user_id)
        db.session.add(profile)
    
    # 3. Update Fields (Only update what is sent)
    if 'full_name' in data: profile.full_name = data['full_name']
    if 'email' in data: profile.email = data['email']
    if 'employment_type' in data: profile.employment_type = data['employment_type']
    if 'monthly_income' in data: profile.monthly_income = data['monthly_income']
    if 'pan_number' in data: profile.pan_number = data['pan_number']
    if 'dob' in data: profile.dob = data['dob'] # You might need to parse Date string here

    # 4. Save
    try:
        db.session.commit()
        return jsonify({
            'message': "Profile Updated Successfully", 
            'profile': profile.to_dict()
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500