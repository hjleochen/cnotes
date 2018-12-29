require "commander"
require "sqlite3"

class Cnote
	FILE_NAME = File.expand_path("~/.note.sqlite3")
  DB_NAME = "sqlite3://#{FILE_NAME}"

	def init
		unless File.exists? FILE_NAME
			DB.open DB_NAME do |db|
				db.exec "create table notes (content text)"
			end
		end

		return "init db #{FILE_NAME}"
  end
	
	def add(content)
		return if content.blank?
		DB.open DB_NAME do |db|
			db.exec "insert into notes(content) values (?)", content
		end
	end
  
	def delete(rowid)
		DB.open DB_NAME do |db|
			db.exec "delete from notes where rowid = ?", rowid
		end
  end

	def list
		find_by_sql("select rowid,content from notes order by rowid")
  end

	def search(key_words)
		find_by_sql("select rowid,content from notes where content like ? order by rowid","%"+key_words+"%")
	end

	def find_by_sql(sql, *args)
		DB.open DB_NAME do |db|
			db.query(sql, *args) do |rs|
				rs.each do
					puts "\n" + "-" * 10 + "#{rs.read(Int32)}" + "-" * 10
					puts rs.read(String)
				end
			end
		end
	end
end


cnote = Cnote.new
cnote.init

cli = Commander::Command.new do |cmd|
  cmd.use = "notes"
  cmd.long = "notes utility save data in local sqlite3 database."

  cmd.run do |options, arguments|
    puts cmd.help
  end

	cmd.commands.add do |cmd|
    cmd.use = "init"
    cmd.short = "init sqlite3 db."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
			puts cnote.init
    end
	end

	cmd.commands.add do |cmd|
    cmd.use = "a"
    cmd.short = "add note."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
			cnote.add arguments.join(" ")
    end
	end

	cmd.commands.add do |cmd|
    cmd.use = "l"
    cmd.short = "list all notes."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
			cnote.list
    end
	end

	cmd.commands.add do |cmd|
    cmd.use = "d"
    cmd.short = "delete note by id."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
			if arguments.size == 0
				puts cmd.help	
			else
				cnote.delete arguments[0]
			end
    end
	end

	cmd.commands.add do |cmd|
    cmd.use = "s"
    cmd.short = "search notes by keywords."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
			if arguments.size == 0
				puts cmd.help	
			else
				cnote.search arguments.join(" ")
			end
    end
	end
end

Commander.run(cli, ARGV)
