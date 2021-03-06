module AresMUSH
  module Website
    class CharacterGalleryMarkdownExtension
      def self.regex
        /\[\[chargallery ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input
        
        helper = TagMatchHelper.new(input)
        
        matches = Character.all.select { |c| 
          ((c.profile_tags & helper.or_tags).any? && 
          (c.profile_tags & helper.exclude_tags).empty?) &&
          (helper.required_tags & c.profile_tags == helper.required_tags)
        }
      
        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'char_gallery.hbs'))

        data = {
          "chars" => matches.sort_by { |c| c.name }.map { |c| { name: c.name, icon: WebHelpers.icon_for_char(c) }},
          "title" => ""
        }
        
        template.render(data)        
      end
    end
  end
end


