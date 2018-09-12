# List of documents returned from a search
class DocList
  include Enumerable
  attr_accessor :items, :srchParams, :pageNum, :pageCount

  def initialize; end

  def addDoc(ndoc)
    @items ||= []
    @items << ndoc
  end

  def addAll(dlist)
    @items ||= []
    dlist&.each { |docItem| @items << docItem }
  end

  def getDocs
    @items
  end

  def size
    @items.count
  end

  def each(&block)
    @items.each(&block)
  end

  # This subclass is used to auto-generate the RESTful data structure.  It is generally not useful for internal Ruby usage
  #  but must be included for full RESTful functionality.
  class Entity < Grape::Entity
    expose :items, using: DocResult::Entity
    expose :srchParams, using: SearchRequest::Entity
  end
end
