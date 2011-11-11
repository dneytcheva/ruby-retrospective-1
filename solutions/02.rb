class Song
  
  attr_accessor :name, :artist, :genre, :subgenre, :tags
    
  def initialize(name, artist, genre, subgenre, tags)
    @name = name
    @artist = artist
    @genre = genre
    @subgenre = subgenre
    @tags = tags
  end
  
  def check?(criteria)
    criteria.all? do |type, value|
      case type
        when :name then @name == value
        when :artist then @artist == value
        when :filter then value.(self)
        else check_tags?(value)
      end
    end
  end
  
  def check_tags?(tags)
    tmp_tags = @tags.map { |tag| tag.to_s }.join(",")
    case tags
      when String then tags.split(",").all? { |tag| tmp_tags.include?(tag) } 
      when Array then exclude_include_tags(tags, tmp_tags)
    end
  end
  
  def exclude_include_tags(tags, tmp_tags)
    tags_exclude = tags.select { |tag| tag.end_with?('!') }
    tags_include = tags.select { |tag| not tag.end_with?('!') }
    tags_exclude.none? { |tag| tmp_tags.include?(tag.chomp('!')) } and
    tags_include = tags_include.all? { |tag| tmp_tags.include? (tag) }
  end
  
end


class Collection
  attr_accessor :songs
   
  def initialize(songs, artist_tags)
    @songs = songs.lines.map { |song| parse_song(song) }
    add_tags(artist_tags)
  end
  
  def parse_song(string_song)
    name, artist, genres, tags = string_song.split('.').map(&:strip)
    genre, subgenre = genres.split(', ')  
    tags ? tags << ", " << genres.downcase : tags = genres.downcase
    tags = tags.split(', ')
    song = Song.new(name, artist, genre, subgenre, tags)
    song   
  end   
  
  def add_tags(artist_tags)
    artist_tags.each do |artist, tags|
      add_tags = @songs.select { |song| song.artist == artist }
      add_tags.map { |song| song.tags = song.tags + tags }      
    end
  end 
                                            
  def find(criteria)
    @songs.select { |song| song.check?(criteria) }
  end
end 
