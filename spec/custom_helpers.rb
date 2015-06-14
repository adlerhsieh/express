module CustomHelpers
  def set_meta_tags(setting=nil)
    allow(controller).to receive(:load_settings).and_return(nil)
  end
end
