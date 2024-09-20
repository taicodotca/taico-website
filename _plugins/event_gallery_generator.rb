# _plugins/event_gallery_generator.rb

module Jekyll
  class EventGalleryPageGenerator < Generator
    safe true

    def generate(site)
      site.posts.docs.each do |post|
        if post.data['categories'].include?('event') && post.data['gallery']
          gallery_page = GalleryPage.new(site, post)
          site.pages << gallery_page
        end
      end
    end
  end

  class GalleryPage < Page
    def initialize(site, post)
      @site = site
      @base = site.source
      @dir = File.join('galleries', post.data['slug'])
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'event-gallery.html')

      gallery_path = File.join(site.source, post.data['gallery'])
      self.data['gallery_images'] = Dir.glob(File.join(gallery_path, '*.{jpg,jpeg,png,gif}')).map { |img| img.sub(site.source, '') }

      self.data['title'] = post.data['title']
      self.data['date'] = post.data['date']
      self.data['location'] = post.data['location']
      self.data['event_url'] = post.url
    end
  end
end