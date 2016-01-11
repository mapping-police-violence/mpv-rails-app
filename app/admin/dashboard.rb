ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do

    # Import buttons for CSV files
    columns do
      column do
        span class: 'dashboard_button' do
          link_to 'Import from The Counted', :controller => 'admin/incidents', :action => 'upload_file', :type => 'the_counted'
        end
        span class: 'dashboard_button' do
          link_to 'Import from Fatal Encounters', :controller => 'admin/incidents', :action => 'upload_file', :type => 'fatal_encounters'
        end
        span class: 'dashboard_button' do
          link_to 'Import from Killed By Police', :controller => 'admin/incidents', :action => 'upload_file', :type => 'killed_by_police'
        end
        span class: 'dashboard_button' do
          link_to 'Re-import MPV data', :controller => 'admin/incidents', :action => 'upload_file', :type => 'mpv'
        end
        span class: 'dashboard_button' do
          link_to 'Download CSV', :controller => 'admin/incidents', :action => 'download_file'
        end
      end
    end

    section "Recently updated content" do
      table_for PaperTrail::Version.order('id desc').limit(20) do # Use PaperTrail::Version if this throws an error
        column ("Item") { |v| link_to v.item, [:admin, v.item] }
        column ("Modified at") { |v| v.created_at.to_s :long }
        column ("By") { |v| v.whodunnit.present? ? link_to(AdminUser.find(v.whodunnit).email, [:admin, AdminUser.find(v.whodunnit)]) : 'Unknown User' }
      end
    end
  end
end
