require "rubygems"
require "interface"
require "molgenis"
require "tempfile"
require "stringio"
#gem "molgenis-gem"

if __FILE__ == $0
  
  #f = File.new("../molgenis-gem/test/test2.xml","r")
  #git+ssh://git@github.com/joerivandervelde/molgenis-myexperiment.git
  
  path = "../molgenis-gem/test/"
  files = ["test1.xml","pheno_db.xml","fuge_db.xml","xgap_db_nochromosome.xml"]
  
  files.each { |file|
    
    #f2 = File.new("../molgenis-gem/test/error1.xml","r")
    f = File.new(path+file)
    puts "testing "+f.path
    mp = WorkflowProcessors::Molgenis.new(f)
    
    puts WorkflowProcessors::Molgenis.display_name
    
    puts "\ntest get title\n"
    puts mp.get_title
    puts
    
    puts "\ntest description\n"
    puts mp.get_description
    
    puts "\ntest error\n"
    puts WorkflowProcessors::Molgenis.recognised?(f) ? "true" : "false" 
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
    
    
    #test get search terms
    puts "\ntest get search terms"
    terms = mp.get_search_terms
    puts terms
    
    puts "test completed"
  }
  
end
