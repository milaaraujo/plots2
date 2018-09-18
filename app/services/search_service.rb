class SearchService
  def initialize; end

  # Run a search in any of the associated systems for references that contain the search string
  def textSearch_all(search_criteria)
    notes = textSearch_notes(search_criteria.query)

    search_criteria.sort_by = "recent"
    profiles = profiles(search_criteria)

    tags = textSearch_tags(search_criteria.query)

    maps = find_maps(search_criteria.query)

    questions = textSearch_questions(search_criteria.query)

    all_results = { :notes => notes,
                    :profiles => profiles,
                    :tags => tags,
                    :maps => maps,
                    :questions => questions }
  end

  # Search profiles for matching text with optional order_by=recent param and
  # sorted direction DESC by default

  # If no sort_by value present, then it returns a list of profiles ordered by id DESC
  # a recent activity may be a node creation or a node revision
  def profiles(search_criteria)
    user_scope = find_users(search_criteria.query, search_criteria.limit, search_criteria.field)

    user_scope =
      if search_criteria.sort_by == "recent"
        user_scope.joins(:revisions)
                  .order("node_revisions.timestamp #{search_criteria.order_direction}")
                  .distinct
      else
        user_scope.order(id: :desc)
      end

    users = user_scope.limit(search_criteria.limit)
  end

  def textSearch_notes(srchString, limit = 25)
    Node.order('nid DESC')
        .where('type = "note" AND node.status = 1 AND title LIKE ?', '%' + srchString + '%')
        .distinct
        .limit(limit)
  end

  def find_maps(srchString)
    Node.where('type = "map" AND node.status = 1 AND title LIKE ?', '%' + srchString + '%')
        .limit(5)
  end

  # The search string that is passed in is split into tokens, and the tag names are compared and
  # chained to the notes that are tagged with those values
  def textSearch_tags(srchString)
    sterms = srchString.split(' ')
    tlist = Tag.where(name: sterms)
      .joins(:node_tag)
      .joins(:node)
      .where('node.status = 1')
      .select('DISTINCT node.nid,node.title,node.path')
  end

  def textSearch_questions(srchString)
    questions = Node.where(
      'type = "note" AND node.status = 1 AND title LIKE ?',
      '%' + srchString + '%'
    )
      .joins(:tag)
      .where('term_data.name LIKE ?', 'question:%')
      .order('node.nid DESC')
      .distinct
      .limit(10)
  end

  # Search nearby nodes with respect to given latitude, longitute and tags
  def tagNearbyNodes(srchString, tagName)
    raise("Must separate coordinates with ,") unless srchString.include? ","

    lat, lon = srchString.split(',')

    nodes_scope = NodeTag.joins(:tag)
      .where('name LIKE ?', 'lat:' + lat[0..lat.length - 2] + '%')

    if tagName.present?
      nodes_scope = NodeTag.joins(:tag)
                           .where('name LIKE ?', tagName)
                           .where(nid: nodes_scope.select(:nid))
    end

    nids = nodes_scope.collect(&:nid).uniq || []

    items = Node.includes(:tag)
      .references(:node, :term_data)
      .where('node.nid IN (?) AND term_data.name LIKE ?', nids, 'lon:' + lon[0..lon.length - 2] + '%')
      .limit(200)
      .order('node.nid DESC')

    # selects the items whose node_tags don't have the location:blurred tag
    items.select do |item|
      item.node_tags.none? do |node_tag|
        node_tag.name == "location:blurred"
      end
    end
  end

  # Returns the location of people with most recent contributions.
  # The method receives as parameter the number of results to be
  # returned and as optional parameter a user tag. If the user tag
  # is present, the method returns only the location of people
  # with that specific user tag.
  def people_locations(srchString, user_tag = nil)
    user_locations = User.where('rusers.status <> 0')\
                         .joins(:user_tags)\
                         .where('value LIKE "lat:%"')\
                         .includes(:revisions)\
                         .order("node_revisions.timestamp DESC")\
                         .distinct
    if user_tag.present?
      user_locations = User.joins(:user_tags)\
                       .where('user_tags.value LIKE ?', user_tag)\
                       .where(id: user_locations.select("rusers.id"))
    end

    user_locations.limit(srchString)
  end

  def find_users(query, limit, type = nil)
    users =
      if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
        type == "username" ? User.search_by_username(query).where('rusers.status = ?', 1) : User.search(query).where('rusers.status = ?', 1)
      else
        User.where('username LIKE ? AND rusers.status = 1', '%' + query + '%')
      end
    users = users.limit(limit)
  end

  def find_nodes(input, _limit = 5, order = :default)
    Node.search(query: input, order: order, limit: 5)
        .group(:nid)
        .where('node.status': 1)
        .distinct
  end
end
