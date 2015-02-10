require "mini_portile"


class MiniPortile
 def extract_file(file, target)
    filename = File.basename(file)
    FileUtils.mkdir_p target

    message "Extracting #{filename} into #{target}... "
    result = `#{tar_exe} #{tar_compression_switch(filename)}xf "#{file}" --no-same-owner -C "#{target}" 2>&1`
    if $?.success?
      output "OK"
    else
      output "ERROR"
      output result
      raise "Failed to complete extract task"
    end
  end
end

recipe = MiniPortile.new("ruby", "1.9.3")

recipe.files = ["http://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p551.tar.gz"]

recipe.configure_options << "--enable-load-relative"
recipe.configure_options << "--disable-install-doc"

recipe.cook

puts "------> Find the build in #{recipe.path}"

