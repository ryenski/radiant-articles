class String
  def to_slug
    self.downcase.gsub(/[^-a-z0-9]+/, "-")
  end
end


class CreateDepartments < ActiveRecord::Migration
  def self.up
      # Create categories
      ["Articles",
       "Events",
       "Event Recaps",
       "Proposals",
       "Jobs",
       "Volunteer Opportunities",
       "Announcements"].each do |category|
         say "creating category #{category}"
         Category.create(:title => category, :slug => category.to_slug, :breadcrumb => category)
       end
      
      # Create departments
      ["Emmerson",
      "South Horton",
      "North Horton",
      "Sigma",
      "Hart",
      "Alpha East",
      "Alpha West",
      "Hope North",
      "Hope South",
      "Stewart",
      "We-T-Li",
      "Rosecrans Apartmemts",
      "Commuters",
      "Chapel Board",
      "Intramurals",
      "ISA",
      "Religious & Academic Relations",
      "Spirit Board",
      "Social Board",
      "AS Marketing",
      "MCR",
      "Chimes"].each do |department|
        say "creating department #{department}"
        Department.create(:title => department, :slug => department.to_slug)
      end
      
      # TODO:
      # Associate users with departments

  end
  
  def self.down
    Category.delete_all
    Department.delete_all
  end
  
end