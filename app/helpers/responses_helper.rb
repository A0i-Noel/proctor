module ResponsesHelper
  def role_filter_button(label, url, active:)
    classes = "px-3 py-1 rounded-md text-sm border transition"
    classes << if active
      " bg-indigo-600 text-white border-indigo-600"
    else
      " bg-white text-gray-700 border-gray-300 hover:bg-gray-50"
    end
    link_to label, url, class: classes
  end
end
