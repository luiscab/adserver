desc "Install gems that this app depends. May need to be run with sudo."
task :install_dependencies do
  dependencies = {
    "sinatra"         => "0.9.4",
    "dm-core"         => "0.10.2",
    "dm-timesstamps"  => "0.10.2",
    "do_sqlite3"      => "0.10.1.1", 
  }
  dependencies.each do |gem_name, version|
    puts "#{gem_name} #{version}"
    system "gem install #{gem_name} --version #{version}"
  end
end