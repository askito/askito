module QuestionnaireDisplayElementsBuilder
  
  def descriptive_text(content)
    nil
  end
  
  def pagebreak(content)
    nil
  end
  
  def image(content)
    images = []
    content.assets.each do |asset|
      if asset.image?
        if content.settings && content.settings[:gallery] == '1'
          rel = content.assets.size > 1 ? "gallery_#{dom_id(content)}" : nil
          images << thickbox_link(asset, rel)
        else
          images << image_tag(asset.public_filename(:big), :style => 'width:100%;', :alt => h(asset.alt), :title => h(asset.caption))
          images << content_tag("p", h(asset.caption), :class => 'image-caption') unless asset.caption.blank?
        end
      end
    end
    images.join
  end
  
  def fields_for_descriptive_text(content, form_obj)
    if defined? TextileEditorHelper
      # use haml helper
      puts find_and_preserve(textile_editor('content', 'text', :class => 'l', :onbeforepaste => "adjustTextarea(this, 150)", :oninput => "adjustTextarea(this, 150)", :onkeypress => "adjustTextarea(this, 150)"))
      textile_editor_initialize
    else
      form_obj.text_area(:text, :class => 'l')
    end
  end
  
  def fields_for_image(content, form_obj)
    haml_tag :ul, :id => 'assets' do
      content.assets.each do |asset|
        puts fields_for_asset_item(asset)
      end
    end
    # haml_tag :p do
    #   puts link_to_function("Add image", update_page{|page| page.insert_html :bottom, 'assets', render(:text => fields_for_asset_item(Asset.new))})
    # end
    # puts link_to_function("Add image", update_page{|page| page.insert_html :bottom, 'assets', a = fields_for_asset_item(Asset.new)})
    haml_tag :fieldset do
      haml_tag :legend, 'Settings'
      haml_tag :p do
        # content.settings ||= {}
        fields_for 'content[settings]', content.settings ||= {} do |cs|
          puts cs.check_box(:gallery, {:checked => content.settings[:gallery] == '1'})
          haml_tag "span", "Display as gallery?"
        end
      end
    end
    
    
  end
  
  
  
protected
  
  def thickbox_link(asset, rel = nil)
    link_to(image_tag(asset.public_filename(:thumb)), asset.public_filename, :title => asset.caption, :class => 'thickbox', :rel => rel)
  end
  
  def fields_for_asset_item(asset)
    prefix = asset.new_record? ? 'new' : 'existing'
    # haml_tag :li, :class => 'clear' do
    content_tag "li", :class => 'clear' do
      
      airbudd_fields_for "content[#{prefix}_asset_attributes][]", asset do |a|
        haml_tag :fieldset, :class => 'clear' do
          haml_tag :div, :class => 'left-half' do
            puts image_tag(asset.public_filename(:thumb)) unless asset.new_record?
          end
          haml_tag :div, :class => 'right-half' do
            a.text_field(:caption, :class => 'l')
            a.text_field(:alt, :label => 'Description', :class => 'l')
            a.file_field(:uploaded_data, :label => 'Upload file', :size => 10)
          end
        end
      end
    end
  end
  
  
  # def fields_for_asset_item(asset)
  #   prefix = asset.new_record? ? 'new' : 'existing'
  #   airbudd_fields_for "content[#{prefix}_asset_attributes][]", asset do |a|
  #     haml_tag :fieldset do
  #       haml_tag :div, :class => 'thumb' do
  #         puts image_tag(asset.public_filename(:thumb)) unless asset.new_record?
  #       end
  #       haml_tag :div, :class => 'meta' do
  #         puts a.text_field(:caption, :class => 'l')
  #         puts a.text_field(:alt, :label => 'ALT', :class => 'l')
  #         puts a.file_field(:uploaded_data, :label => 'Upload file', :size => 30)
  #       end
  #     end
  #   end
  # end
  
  
  
  
end