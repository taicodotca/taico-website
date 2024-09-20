module Jekyll
  class EventGalleryTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @max_galleries = text.strip.empty? ? 4 : text.to_i
    end

    def render(context)
      site = context.registers[:site]
      
      events = site.posts.docs.select { |post| post.data['categories'].include?('event') && post.data['gallery'] }
      events = events.sort_by { |event| event.data['date'] }.reverse.take(@max_galleries)
      
      result = []

      events.each do |event|
        gallery_path = event.data['gallery']
        image_files = Dir.glob(File.join(site.source, gallery_path, '*.{jpg,jpeg,png,gif}'))
        
        if image_files.any?
          selected_image = image_files.first
          result << image_card(selected_image, event, site)
        end
      end

      Jekyll.logger.info "EventGalleryTag:", "Processed #{result.length} galleries"

      result.join("\n")
    end

    private

    def image_card(image_path, event, site)
      relative_path = image_path.sub(site.source, '')
      path_400w = relative_path.sub(/(\.[^.]+)$/, '-400w\1')

      gallery_url = "/galleries/#{event.data['slug']}/"
      <<~HTML
        <a href="#{gallery_url}" class="block bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow duration-300">
          <div class="relative w-full pt-[56.25%]">
            <img src="#{path_400w}" alt="#{event.data['title']} - Gallery Image" class="absolute inset-0 w-full h-full object-cover">
          </div>
          <div class="p-4">
            <h3 class="text-xl font-semibold mb-2 text-primary group-hover:text-accent transition-colors duration-300">#{event.data['title']}</h3>
            <p class="text-sm text-secondary mb-2">#{event.data['date'].strftime('%B %d, %Y')} • #{event.data['location']}</p>
          </div>
        </a>
      HTML
    end
  end
end

Liquid::Template.register_tag('event_gallery', Jekyll::EventGalleryTag)