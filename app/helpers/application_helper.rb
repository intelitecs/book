module ApplicationHelper

  def title
    base_title = "Book de Lety"
    unless @title.nil?
      @title
    else
      base_title
    end
  end

  def displayImage (imageURL,options = {})
    options = {class: 'image', alt: imageURL}.merge(options)
    image_tag imageURL,options
  end


  def displayBanner(banner, options= {})
    options = {width: 1200, height: 400, alt: "#{banner}"}.merge(options)
    image_tag banner,options
  end


  def link_to_self(name= nil, options =nil, html_options = nil,&block)
    html_options = {}
    html_options.merge!({target: '_self'})
    html_options, options = options, name if block_given?
    options ||= {}
    html_options = convert_options_to_data_attributes(options, html_options)
    url = url_for(options)
    html_options['href'] ||= url
    content_tag(:a, name || url, html_options, &block)
  end


end
