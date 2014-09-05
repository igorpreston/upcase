class Catalog
  include ActiveModel::Conversion

  def products
    Product.active.ordered
  end

  def books
    Book.active.ordered
  end

  def video_tutorials
    VideoTutorial.only_active.by_position
  end

  def screencasts
    Screencast.active.newest_first
  end

  def shows
    Show.active.ordered
  end

  def exercises
    Exercise.ordered
  end

  def mentors
    Mentor.all
  end

  def individual_plans
    IndividualPlan.featured.active.ordered
  end

  def videos
    Video.published.recently_published_first
  end
end
