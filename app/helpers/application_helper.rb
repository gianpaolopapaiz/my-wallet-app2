module ApplicationHelper
  def nice_date(date)
    date.strftime('%m/%d/%y')
  end

  def long_date(date)
    date.strftime('%B %d, %Y')
  end

  def number_class(value)
    value.positive? ? 'positive-number' : 'negative-number'
  end
end
