class HomeBanner < ApplicationRecord

  has_one_attached :banner
  has_one_attached :mobile_banner
  has_one_attached :iphone_se
  has_one_attached :samsung_galaxy_s7
  has_one_attached :samsung_galaxy_s9
  has_one_attached :iphone_8
  has_one_attached :iphone_11_pro
  has_one_attached :pixel_3
  has_one_attached :pixel_3a
  has_one_attached :pixel_4
  has_one_attached :nexus_6p_pixel_1_2
  has_one_attached :iphone_8_plus
  has_one_attached :googel_pixel_4_xl
  has_one_attached :iphone_11_pro_max
  has_one_attached :google_pixel_2_xl
  has_one_attached :google_pixel_3_xl
  has_one_attached :google_pixel_3a_xl
  has_one_attached :samsung_galaxy_note_5
  has_one_attached :nexus_7
  has_one_attached :ipad_third__fourth_generation
  has_one_attached :ipad_7
  has_one_attached :ipad_air
  has_one_attached :ipad_11
  has_one_attached :samsung_galaxy_tab_10
  has_one_attached :ipad_pro
  has_one_attached :chromebook_pixel
  validates :banner, content_type: ['image/png', 'image/jpg', 'image/jpeg'], dimension: { width: 1500, height: 450}
  validates :mobile_banner, content_type: ['image/png', 'image/jpg', 'image/jpeg'], dimension: { width: 676, height: 676}


  UNIQUE_VIEWPORTS.each do |viewport|
    validates viewport.first, content_type: ['image/png', 'image/jpg', 'image/jpeg'], dimension: { width: viewport.second[:width], height: viewport.second[:height] - viewport.second[:browser] - 100}
  end

  def am_i_valid?
    unique_viewports.keys.all?{|attachment| self.send(attachment)&.attached?}
  end

  def ordered_array_with_image_paths
    viewport_array_ordered_by_width.map do |r|
      [r, self.safe_url(r[0])]
    end
  end

  def safe_url(key)
    if self.send(key).attached?
      self.send(key)
    else
      "about-us-ariel-border.png"
    end
    # key if self.send(key).attached? : asset_path('sctivity.png')
  end

end



































