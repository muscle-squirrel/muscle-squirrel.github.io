# frozen_string_literal: true

module MuscleSquirrel
  class AuthorPage < Jekyll::PageWithoutAFile
    def initialize(site, id, info, posts)
      super(site, site.source, File.join("authors", id), "index.html")
      self.content = ""
      data.merge!(
        "layout"    => "author",
        "title"     => info["name"] || id,
        "member_id" => id,
        "github"    => info["url"],
        "posts"     => posts
      )
    end
  end

  class AuthorPageGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      authors = site.data["authors"]
      return unless authors.is_a?(Hash)

      # 최신 글이 위로 오도록 정렬
      all_posts = site.posts.docs.sort_by(&:date).reverse

      authors.each do |id, info|
        info = {} unless info.is_a?(Hash)
        posts = all_posts.select { |post| authors_of(post).include?(id.to_s) }
        site.pages << AuthorPage.new(site, id.to_s, info, posts)
      end
    end

    private

    def authors_of(post)
      Array(post.data["authors"] || post.data["author"]).map(&:to_s)
    end
  end
end
