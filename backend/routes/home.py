from flask import Blueprint, request, jsonify
from models import UserProfile

home_bp = Blueprint('home', __name__)

@home_bp.route('/dashboard', methods=['GET'])
def get_dashboard_data():
    user_id = request.args.get('user_id')
    if not user_id: return jsonify({'error': "User ID required"}), 400

    profile = UserProfile.query.filter_by(user_id=user_id).first()
    if not profile: return jsonify({'error': "Profile not found"}), 404

    # --- STRICT ELIGIBILITY ENGINE ---
    eligible_loans = []

    # 1. STUDENT LOGIC (Strict)
    if profile.employment_type == 'Student':
        eligible_loans.append({
            "title": "Pocket Money",
            "max_amount": "₹10,000",
            "interest": "0% for 30 days",
            "icon": "🎓",
            "color": "0xFF6C63FF" # Purple
        })
        eligible_loans.append({
            "title": "Education Loan",
            "max_amount": "₹5,00,000",
            "interest": "0.8% / mo",
            "icon": "📚",
            "color": "0xFFFFA726" # Orange
        })

    # 2. SALARIED LOGIC (Strict)
    elif profile.employment_type == 'Salaried':
        eligible_loans.append({
            "title": "Instant Salary",
            "max_amount": "₹50,000",
            "interest": "1.5% / mo",
            "icon": "⚡",
            "color": "0xFF29B6F6" # Light Blue
        })
        eligible_loans.append({
            "title": "Personal Loan",
            "max_amount": f"₹{int(profile.monthly_income * 10):,}", # 10x Salary
            "interest": "1.1% / mo",
            "icon": "💼",
            "color": "0xFF66BB6A" # Green
        })
        
        # High Income Bonus
        if profile.monthly_income > 50000:
             eligible_loans.append({
                "title": "Premium Card",
                "max_amount": "Limit: ₹3L",
                "interest": "Lifetime Free",
                "icon": "💳",
                "color": "0xFFAB47BC" # Purple
            })

    # 3. SELF-EMPLOYED LOGIC
    elif profile.employment_type == 'Self-Employed':
        eligible_loans.append({
            "title": "Business Loan",
            "max_amount": "₹2,00,000",
            "interest": "1.8% / mo",
            "icon": "🚀",
            "color": "0xFFEF5350" # Red
        })

    return jsonify({
        "user_name": profile.full_name,
        "eligible_loans": eligible_loans
    }), 200