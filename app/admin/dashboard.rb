ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    # Import buttons for CSV files
    columns do
      column do
        span class: "dashboard_button" do
          link_to "Import CSV from The Counted", :controller => 'admin/incidents', :action => 'upload_csv', :type => 'the_counted'
        end
        span class: "dashboard_button" do
          link_to "Import CSV from Fatal Encounters", :controller => 'admin/incidents', :action => 'upload_csv', :type => 'fatal_encounters'
        end
        span class: "dashboard_button" do
          link_to "Import CSV from Killed By Police", :controller => 'admin/incidents', :action => 'upload_csv', :type => 'killed_by_police'
        end

      end
    end # content
  end
end
