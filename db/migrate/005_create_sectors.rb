class CreateSectors < ActiveRecord::Migration

  def self.up
    transaction do
      
      create_table :sectors do |t|
        t.column :title, :string
        t.column :slug, :string
      end
      
      execute %{INSERT INTO sectors (title, slug) VALUES ("Senate", "senate")}
      execute %{INSERT INTO sectors (title, slug) VALUES ("Services", "services")}
      
      senate = Sector.find_by_title("Senate")
      services = Sector.find_by_title("Services")
      # senate = Sector.create(:title => "Senate", :slug => "senate")
      # services = Sector.create(:title => "Services", :slug => "services")
      
      # add_column :departments, :sector_id, :integer
      execute %{ALTER TABLE departments ADD COLUMN sector_id integer}
      
      senate_titles = ["Emmerson", "South Horton", "North Horton", "Sigma", "Hart", "Alpha East", "Alpha West", "Hope North", "Hope South", "Stewart", "We-T-Li", "Rosecrans Apartmemts", "Commuters"]
      services_titles = ["Chapel Board", "Intramurals", "ISA", "Religious & Academic Relations", "Spirit Board", "Social Board", "AS Marketing", "MCR", "Chimes"]
      
      for sector in senate_titles
        Department.update_all("sector_id = #{senate.id}", "title = '#{sector}'")
      end
      
      for sector in services_titles
        Department.update_all("sector_id = #{services.id}", "title = '#{sector}'")
      end
      
    end
  end
  
  def self.down
    transaction do
      drop_table :sectors
      remove_column :departments, :sector_id
    end
  end
end