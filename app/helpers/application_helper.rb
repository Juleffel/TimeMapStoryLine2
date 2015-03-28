module ApplicationHelper
 
  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end
  
  def time_ago(time)
    t('time_ago_before')+" "+time_ago_in_words(time)+" "+t('time_ago_after')
  end
end