module SessionsHelper
    # Logs in the given user.
    def log_in(user)
        session[:user_id] = user.id
    end

    # Returns the current logged-in user (if any).
    # def current_user
    #     current_user ||= User.find_by(id: session[:user_id])
    # end

    # Returns true if the user is logged in, false otherwise.
    def logged_in?
        user_signed_in? || !current_user.nil?
    end

    # Logs out the current user.
    def log_out
        session.delete(:user_id)
        @current_user = nil
    end

    # Returns most reviewed courses
    def get_courses_most_reviewed num
        ids = Course.joins(:reviews).group(:id).count(:all).sort_by {|k,v| v}.reverse.first(num).to_h.keys
        courses = Course.where(id: ids)
        return get_hash_result courses, true
    end
    
    # Returns most reviewed professors
    def get_professors_most_reviewed num
        ids = Professor.joins(:reviews).group(:id).count(:all).sort_by {|k,v| v}.reverse.first(num).to_h.keys
        professors = Professor.where(id: ids)
        return get_hash_result professors, false
    end

    def get_hash data
        arr = (data['course_title']) ?
            ["Content", "Participation", "Workload", "Testing", "Grading"] :
            ["Delivery", "Accessibility", "Expertise", "Expectations", "Preparedness"] 
            
        res = {}
        (1..5).each do |num|
            res["avg_cat" + num.to_s] = arr[num-1]
        end
        res
    end

    def icon_for score
        if score == "N/A"
            return content_tag :i, '', class: 'far fa-question-circle fa-2x text-secondary'
        end
        score = score.to_f * 100
        icon = case score
            when 0..133 then content_tag :i, '', class: 'far fa-frown fa-2x text-danger'
            when 134..332 then content_tag :i, '', class: 'far fa-meh fa-2x text-info'
            when 333..449 then content_tag :i, '', class: 'far fa-smile-beam fa-2x text-success'
            when 450..500 then content_tag :i, '', class: 'far fa-grin-stars fa-2x text-warning'
        end
        icon
    end
end
