module Thesis
  class ThesisController < ::ApplicationController
    include Thesis::ControllerHelpers

    def show
      raise ActionController::RoutingError.new('Not Found') unless current_page

      if current_page.template && template_exists?("page_templates/#{current_page.template}")
        render "page_templates/#{current_page.template}", layout: false
      else
        raise PageRequiresTemplate.new("Page requires a template but none was specified.")
      end
    end
    
    def new_page      
      page = Page.new
      return head :forbidden unless page_is_editable?(page)

      update_page_attributes page

      head page.save ? :ok : :not_acceptable
    end
    
    def update_page
      page = current_page
      return head :forbidden unless page_is_editable?(page)

      update_page_attributes page
      
      head page.save ? :ok : :not_acceptable
    end

    def page_attributes
      [ :name, :title, :description, :parent_id ]
    end
    
    def update_page_attributes(page)
      page_attributes.each { |a| page.send("#{a}=", params[a]) if params[a] }
      page
    end
    
    # The ApplicationController should implement this.
    def page_is_editable?(page)
      raise RequiredMethodNotImplemented.new("Add a `page_is_editable?(page)` method to your controller that returns true or false.") unless defined?(super)
      super
    end
  end
end
