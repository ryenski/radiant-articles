namespace :radiant do
  namespace :extensions do
    namespace :articles do
      
      desc "Runs the migration of the Articles extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ArticlesExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ArticlesExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Articles to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[ArticlesExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ArticlesExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
