# myExperiment: lib/workflow_processors/interface.rb
#
# Copyright (c) 2008 University of Manchester and the University of Southampton.
# See license.txt for details.

# Defines an interface that all workflow type processors need to adhere to.
module WorkflowProcessors
  #require 'file_upload'


  class MolgenisProcessor
    
    # Begin Class Methods
    
    # These: 
    # - provide information about the Workflow Type supported by this processor,
    # - provide information about the processor's capabilites, and
    # - provide any general functionality.
    
    # MUST be unique across all processors
    def self.display_name
      "MOLGENIS application model"
    end
    
    def self.display_data_format
      "MOLGENIS"
    end
    
    # All the file extensions supported by this workflow processor.
    # Must be all in lowercase.
    def self.file_extensions_supported
      ["xml","molgenis"]
    end
    
    def self.can_determine_type_from_file?
      true
    end
    
    def self.recognised?(file)
      molgenis_model = MOLGENIS::Parser.new.parse(file)
      file.rewind
      return !molgenis_model.nil?
    end
    
    def self.can_infer_metadata?
      true
    end
    
    def self.can_generate_preview_image?
      true
    end
    
    def self.can_generate_preview_svg?
      true
    end
    
    # End Class Methods
    
    
    # Begin Object Initializer
    
    def initialize(workflow_definition)
      puts 'constructor of MolgenisProcessor called'
      @molgenis_model = MOLGENIS::Parser.new.parse(workflow_definition)  
    end
    
    # End Object Initializer
    
    
    # Begin Instance Methods
    
    # These provide more specific functionality for a given workflow definition, such as parsing for metadata and image generation.
    
    def get_title
      return nil if @molgenis_model.nil?
      return @molgenis_model.label if(@molgenis_model.label)
      return @molgenis_model.name
    end
    
    def get_description
      return @molgenis_model.description
    end
    
    def get_preview_image
      puts 'called get_preview_image'
      return nil if @molgenis_model.nil? || RUBY_PLATFORM =~ /mswin32/
      
      title = self.get_title
      filename = title.gsub(/[^\w\.\-]/,'_').downcase
      
      i = Tempfile.new("image")
      dotWriter = MOLGENIS::Dot.new.write_dot(i, @molgenis_model)
      puts "dotwriter done #{i.path}.png"
      i.close(false)
      
      img = StringIO.new(`dot -Tpng #{i.path}`)
      img.extend FileUpload
      img.original_filename = "#{filename}.png"
      img.content_type = "image/png"
      img
    end
    
    def get_preview_svg
      return nil if @molgenis_model.nil? || RUBY_PLATFORM =~ /mswin32/
      title = self.get_title
      filename = title.gsub(/[^\w\.\-]/,'_').downcase
      i = Tempfile.new("image")
      MOLGENIS::Dot.new.write_dot(i, @molgenis_model)
      i.close(false)
      
      svg = StringIO.new(`dot -Tsvg #{i.path}`)
                         svg.extend FileUpload
                         svg.original_filename = "#{filename}.svg"
      svg.content_type = "image/svg+xml"
      
      svg
    end
    
    def get_workflow_model_object
      @molgenis_model
    end
    
    def get_workflow_model_input_ports
      nil
    end
    
    def get_search_terms
      return nil if @molgenis_model.nil?
      words = StringIO.new
      
      words << " "+ model.description
      model.entities.each { |e|
        words << " #{e.description}"
        e.fields.each { |f| 
          words << " "+f.description
        } if entity.fields
      } if model.entities
      
      words.rewind
      words.read
    end
    
    def get_components
      model = @molgenis_model
      components = LibXML::XML::Node.new('components')
      
      entities = LibXML::XML::Node.new('entities')
      
      model.entities.each { |entity|
        el = LibXML::XML::Node.new('entity')
        el << (LibXML::XML::Node.new('name') << entity.name)
        el << (LibXML::XML::Node.new('description') << entity.description)
      }
      
      components << entities
      
      components
    end
    
    # End Instance Methods
    
  end
end
