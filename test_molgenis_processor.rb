require "libxml"
require "dependencies.rb"
require "molgenis_processor.rb"
require "../molgenis-gem/lib/molgenis_dot.rb"
require "../molgenis-gem/lib/molgenis_parser.rb"
require "../molgenis-gem/lib/molgenis_model.rb"


if __FILE__ == $0
  
  #f = File.new("../molgenis-gem/test/test2.xml","r")
  
  path = "../molgenis-gem/test/"
  files = ["test1.xml","pheno_db.xml","fuge_db.xml","xgap_db_nochromosome.xml"]
  
  files.each { |file|
  
      #f2 = File.new("../molgenis-gem/test/error1.xml","r")
      f = File.new(path+file)
      puts "testing "+f.path
      mp = WorkflowProcessors::MolgenisProcessor.new(f)
      
      puts WorkflowProcessors::MolgenisProcessor.display_name
      
      puts "\ntest get title\n"
      puts mp.get_title
      puts
      
      puts "\ntest description\n"
      puts mp.get_description
      
      puts "\ntest error\n"
      puts WorkflowProcessors::MolgenisProcessor.recognised?(f) ? "true" : "false" 
      #puts WorkflowProcessors::MolgenisProcessor.recognised?(f2) ? "true" : "false"
      
      
      #test get preview image
      puts "\ntest preview\n"
      img = mp.get_preview_image
      img.rewind
      
      png = File.new(file+".png","w")
      png.write(img.read)
      png.close
      
      #test get preview svg
      puts "\ntest preview\n"
      img = mp.get_preview_svg
      img.rewind
      
      svg = File.new(file+".svg","w")
      svg.write(img.read)
      svg.close  
  }

end
