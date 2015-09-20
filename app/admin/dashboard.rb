ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    # Import buttons for CSV files
    columns do
      column do
          span class: "dashboard_button" do
            link_to "Import CSV from The Counted", :controller => 'admin/incidents', :action => 'upload_csv'
          end
      end

    end
  end # content
end
