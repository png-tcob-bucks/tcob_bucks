module ApplicationHelper

	def buck_sortable(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_buck_column ? "current #{sort_buck_direction}" : nil
	  direction = column == sort_buck_column && sort_buck_direction == "asc" ? "desc" : "asc"
	  link_to title, {:sort => column, :direction => direction,
	  	:search_number => params[:search_number], 
	  	:search_recipient_id => params[:search_recipient_id], 
	  	:search_issuer_id => params[:search_issuer_id],
	  	:show => params[:show]}, {:class => css_class}
	end

	def employee_sortable(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_buck_column ? "current #{sort_buck_direction}" : nil
	  direction = column == sort_buck_column && sort_buck_direction == "asc" ? "desc" : "asc"
	  link_to title, {:sort => column, :direction => direction,
	  	:search_number => params[:search_number], 
	  	:search_recipient_id => params[:search_recipient_id], 
	  	:search_issuer_id => params[:search_issuer_id]}, {:class => css_class}
	end

	def sort_buck_column
    Buck.column_names.include?(params[:sort]) ? params[:sort] : "number"
  end
  
  def sort_buck_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
