#!/usr/bin/env ruby

require 'csv'
require 'yaml'
require 'mysql2'

# TODO(mtwilliams): Use unique identifier rather than naming the container.
# Start a (temporary) MySQL server in the background to import the data.
`docker run -d --name crunchbase -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=crunchbase -P mysql:latest`

# Yank connection information from Docker.
MYSQL_HOST = `docker-machine ip`.strip
MYSQL_PORT = `docker inspect crunchbase | jq '.[0].NetworkSettings.Ports."3306/tcp"[0].HostPort|tonumber'`.strip.to_i

# Download the dump.
CB_USER_KEY = ENV['CB_USER_KEY']
`wget -qO- "https://api.crunchbase.com/v/3/snapshot/crunchbase_2013_snapshot_mysql.tar.gz?user_key=#{CB_USER_KEY}" | tar xzf - -C snapshot`

# Load it into the temporary MySQL server.
`find snapshot -name "*.sql"`.split("\n").each do |snapshot|
  puts "Loading #{snapshot} from snapshot..."

  `
  mysql -h #{MYSQL_HOST} -P #{MYSQL_PORT} \
        --user=root --password=root \
        crunchbase \
        < #{snapshot}
  `
end

# Dump to CSV.
YAML.load_file('queries.yml').each do |name, query|
  puts "Dumping `#{name}.csv`..."

  db = Mysql2::Client.new(
    host: MYSQL_HOST,
    port: MYSQL_PORT,
    username: 'root',
    password: 'root',
    database: 'crunchbase'
  )

  CSV.open("dump/#{name}.csv", "w") do |csv|
    results = db.query(query)
    csv << results.fields
    results.each(cache_rows: false) do |row|
      csv << row.values.map do |value|
        if value.is_a? String
          value.gsub(/(\r\n|\n)/, "\\n")
        else
          value
        end
      end
    end
  end
end

# Clean up after ourselves.
`docker rm -f crunchbase`
