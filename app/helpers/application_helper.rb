module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Mathraining"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  # Transform list of errors in readable html list
  def errors_to_list(errors)
    if errors.count <= 1
      s = "Une erreur est survenue."
    else
      s = "Plusieurs erreurs sont survenues."
    end
    
    if errors.count > 0
      s += "\n<ul>\n"
      errors.each do |msg|
        s += "<li>#{ msg }</li>\n"
      end
      s += "</ul>"
    end
    
    return s.html_safe
  end
  
  # Get html list of errors for an invalid object
  def error_list_for(object)
    return errors_to_list(object.errors.full_messages)
  end

  private

  # To read bbcode on user side
  def bbcode(m)
    (h m.gsub(/\\\][ \r]*\n/,'\] ').
    gsub(/\$\$[ \r]*\n/,'$$ ')).
    gsub(/\[b\](.*?)\[\/b\]/mi, '<b>\1</b>').
    gsub(/\[u\](.*?)\[\/u\]/mi, '<u>\1</u>').
    gsub(/\[i\](.*?)\[\/i\]/mi, '<i>\1</i>').
    gsub(/\[url=(?:&quot;)?(.*?)(?:&quot;)?\](.*?)\[\/url\]/mi, '<a target=\'blank\' href=\'\1\'>\2</a>').
    gsub(/\[hide=(?:&quot;)?(.*?)(?:&quot;)?\][ \r\n]*(.*?)[ \r\n]*\[\/hide\]/mi, '[hide=\1]\2[/hide]').
    gsub(/\n/, '<br>').
    gsub(/\:\-\)/,    image_tag("Smiley1.png", alt: ":-)", width: "20px")).
    gsub(/\:\-\(/,    image_tag("Smiley2.png", alt: ":-(", width: "20px")).
    gsub(/\:\-[D]/,   image_tag("Smiley3.png", alt: ":-D", width: "20px")).
    gsub(/\:\-[O]/,   image_tag("Smiley4.png", alt: ":-O", width: "20px")).
    gsub(/\:\-[P]/,   image_tag("Smiley5.png", alt: ":-P", width: "20px")).
    gsub(/\:&#39;\(/, image_tag("Smiley6.png", alt: ":'(", width: "20px")).
    gsub(/\;\-\)/,    image_tag("Smiley7.png", alt: ";-)", width: "20px")).
    gsub(/\:\-\|/,    image_tag("Smiley8.png", alt: ":-|", width: "20px")).
    gsub(/[3]\:\[/,   image_tag("Smiley9.png", alt: "3:[", width: "20px"))
  end

  # To read code on admin side
  def htmlise(m)
    m2 = m.gsub(/<hr>[ \r]*\n/,'<hr>').
    gsub(/\\\][ \r]*\n/,'\] ').
    gsub(/\$\$[ \r]*\n/,'$$ ').
    gsub(/\n[ \r]*<h2>/,'<h2 class="mt-3">').
    gsub(/\n[ \r]*<h3>/,'<h3 class="mt-3">').
    gsub(/\n[ \r]*<h4>/,'<h4 class="mt-3">').
    gsub(/\n[ \r]*<h5>/,'<h5 class="mt-3">').
    gsub(/<\/h2>[ \r]*\n/,'</h2>').
    gsub(/<\/h3>[ \r]*\n/,'</h3>').
    gsub(/<\/h4>[ \r]*\n/,'</h4>').
    gsub(/<\/h5>[ \r]*\n/,'</h5>').
    gsub(/<ol>/, '<ol class="mb-1">').
    gsub(/<ul>/, '<ul class="mb-1">').
    gsub(/<\/ol>[ \r]*\n/, '</ol>').
    gsub(/\n[ \r]*<\/ol>/, '</ol>').
    gsub(/<\/ul>[ \r]*\n/, '</ul>').
    gsub(/\n[ \r]*<\/ul>/, '</ul>').
    gsub(/\n[ \r]*<li>/, '<li>').
    gsub(/<\/result>[ \r]*\n/, '</result>').
    gsub(/<\/proof>[ \r]*\n/, '</proof>').
    gsub(/<\/remark>[ \r]*\n/, '</remark>').
    gsub(/<statement>[ \r]*\n/, '<statement>')
    
    while m2.sub!(/<result>(.*?)<statement>(.*?)<\/result>/mi) {"<div class='result-title'>#{$1}</div><div class='result-content'>#{$2}</div>"}
    end
    
    while m2.sub!(/<proof>(.*?)<statement>(.*?)<\/proof>/mi) {"<div class='proof-title'>#{$1}</div><div class='proof-content'>#{$2}</div>"}
    end
    
    while m2.sub!(/<remark>(.*?)<statement>(.*?)<\/remark>/mi) {"<div class='remark-title'>#{$1}</div><div class='remark-content'>#{$2}</div>"}
    end
    
    return m2.gsub(/\n/, '<br/>')
  end

  # Method to deal with clues
  def replace_indice(m)
    m2 = m.gsub(/<\/indice>[ \r]*<br\/>/, "</indice>")
    
    while m2.sub!(/<indice>(.*?)<\/indice>/mi) {"<div class='clue-bis'><div><button onclick='return Clue.toggle(0);' class='btn btn-ld-light-dark'>Indice</button></div><div id='indice0' class='clue-hide'><div class='clue-content'>#{$1}</div></div></div>"}
    end
    
    return m2
  end

  # Write 21h50
  def write_hour(date_utc)
    date = date_utc.in_time_zone
    return "#{date.hour}h#{"0" if date.min < 10}#{date.min}"
  end

  # Write 21h
  def write_hour_only(date_utc)
    date = date_utc.in_time_zone
    return "#{date.hour}h"
  end
  
  # Write 12 juin 2009 à 21h50
  def write_date(date_utc)
    date = date_utc.in_time_zone
    mois = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"]
    return "#{ date.day } #{ mois[date.month-1]} #{date.year} à #{date.hour}h#{"0" if date.min < 10}#{date.min}"
  end
  
  # Write 12 juin 2009
  def write_date_only(date_utc)
    date = date_utc.in_time_zone
    mois = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"]
    return "#{ date.day } #{ mois[date.month-1]} #{date.year}"
  end
  
  # Write 12/06/09
  def write_date_only_small(date_utc)
    date = date_utc.in_time_zone
    return "#{ date.day }/#{'0' if date.month < 10}#{ date.month }/#{'0' if date.year-2000 < 10}#{date.year-2000}"
  end
  
  # Write vendredi 12 juin 2009 à 21h50
  def write_date_with_day(date_utc)
    date = date_utc.in_time_zone
    mois = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"]
    jour = ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]
    return "#{ jour[date.wday] } #{ date.day } #{ mois[date.month-1]} #{date.year} à #{date.hour}h#{"0" if date.min < 10}#{date.min}"
  end
  
  # Write vendredi 12 juin 2009
  def write_date_only_with_day(date_utc)
    date = date_utc.in_time_zone
    mois = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"]
    jour = ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]
    return "#{ jour[date.wday] } #{ date.day } #{ mois[date.month-1]} #{date.year}"
  end
  
  # Write vendredi 12 juin 2009 with HTML link to timeanddate.com
  def write_date_with_link(date_utc, contest, contestproblem)
    date = date_utc.in_time_zone
    mois = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"]
    jour = ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]
    return link_to "#{ jour[date.wday] } #{ date.day } #{ mois[date.month-1]} #{date.year} à #{date.hour}h#{"0" if date.min < 10}#{date.min}", "https://www.timeanddate.com/worldclock/fixedtime.html?msg=Mathraining+-+Concours+%23#{contest.number}+-+Probl%C3%A8me+%23#{contestproblem.number}&iso=#{date.year}#{'0' if date.month < 10}#{date.month}#{'0' if date.day < 10}#{date.day}T#{'0' if date.hour < 10}#{date.hour}#{'0' if date.min < 10}#{date.min}&p1=48", :target => "blank_"
  end
  
  # Write vendredi 12 juin 2009 with bbcode link to timeanddate.com
  def write_date_with_link_forum(date_utc, contest, contestproblem)
    date = date_utc.in_time_zone
    mois = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"]
    jour = ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]
    return "[url=https://www.timeanddate.com/worldclock/fixedtime.html?msg=Mathraining+-+Concours+%23#{contest.number}+-+Probl%C3%A8me+%23#{contestproblem.number}&iso=#{date.year}#{'0' if date.month < 10}#{date.month}#{'0' if date.day < 10}#{date.day}T#{'0' if date.hour < 10}#{date.hour}#{'0' if date.min < 10}#{date.min}&p1=48]#{ jour[date.wday] } #{ date.day } #{ mois[date.month-1]} #{date.year} à #{date.hour}h#{"0" if date.min < 10}#{date.min}[/url]"
  end
  
  # Get plural of 'Grand maître', 'Expert', ...
  def pluriel(level)
    newlevel = ""
    (0..level.size-1).each do |i|
      if level[i] == ' '
        newlevel += 's'
      end
      newlevel += level[i]
    end
    newlevel += 's'
    return newlevel
  end
  
  # Tells if user has enough points for problems
  def has_enough_points(user) # user = nil for a non-signed-in user
    if user.nil?
      return false
    elsif user.admin?
      return true
    else
      return (user.rating >= 200)
    end
  end
  
  # Write 1234567 as 1 234 567 (with thin spaces)
  def write_readable_big_number(n)
    return "0" if n == 0
    m = n
    num_digits = 0
    n_string = ""
    while(m > 0)
      if num_digits % 3 == 0 && num_digits > 0
        n_string = "&thinsp;" + n_string
      end
      d = m % 10
      n_string = d.to_s + n_string
      m = m/10
      num_digits += 1
    end
    return n_string
  end
  
  # Methods to write titles
  def title_1(x)
    return "<span class='title-true'>#{ x }</span>".html_safe
  end
  
  def title_2(x, y)
    return "<span class='title-first'>#{ x } ></span> <span class='title-true'>#{ y }</span>".html_safe
  end
  
  def title_3(x, y, z)
    return "<span class='title-first'>#{ x } ></span> <span class='title-second'>#{ y } ></span> <span classs='title-true'>#{ z }</span>".html_safe
  end
  
  def title_4(x, y, z, t)
    return "<span class='title-first'>#{ x } ></span> <span class='title-second'>#{ y } ></span> <span class='title-third'>#{ z } ></span> <span class='title-true'>#{ t }</span>".html_safe
  end
  
  # Titles concerning actualities
  def title_actualities(title)
    return title_2((link_to "Actualités", root_path), title)
  end
  
  # Titles concerning FAQ
  def title_faqs(title)
    return title_2((link_to "Questions fréquemment posées", faqs_path), title)
  end
  
  # Titles concerning pictures
  def title_pictures(title)
    return title_2((link_to "Vos images", pictures_path), title)
  end
  
  # Titles concerning privacypolicies
  def title_privacypolicies(title)
    return title_2((link_to "Politiques de confidentialité", privacypolicies_path), title)
  end
  
  # Titles concerning subjects
  def title_subjects(title)
    return title_2((link_to "Forum", subjects_path(:q => @q)), title)
  end
  
  # Titles concerning virtualtests
  def title_virtualtests(title)
    return title_2((link_to "Tests virtuels", virtualtests_path), title)
  end
  
  # Titles concerning sections / chapters / questions / theories
  def title_section(section, title)
    return title_3("Théorie", (link_to section.name, section), title)
  end
  
  def title_chapter(chapter, title)
    return title_4("Théorie", (link_to chapter.section.name, chapter.section), (link_to chapter.name, chapter), title)
  end
  
  def title_question(question, title)
    return title_4("Théorie", (link_to question.chapter.section.name, question.chapter.section), (link_to question.chapter.name, chapter_question_path(question.chapter, question)), title)
  end
  
  def title_theory(theory, title)
    return title_4("Théorie", (link_to theory.chapter.section.name, theory.chapter.section), (link_to theory.chapter.name, chapter_theory_path(theory.chapter, theory)), title)
  end
  
  # Titles concerning problems
  def title_problems(section, title)
    return title_3("Problèmes", (link_to section.name, section_problems_path(section)), title)
  end
  
  def title_problem(problem, title)
    return title_4("Problèmes", (link_to problem.section.name, section_problems_path(problem.section)), (link_to "Problème ##{ problem.number }", problem), title)
  end
  
  # Titles concerning contests / contestproblems
  def title_contests(title)
    return title_2((link_to "Concours", contests_path), title)
  end  
  
  def title_contest(contest, title)
    return title_3((link_to "Concours", contests_path), (link_to "Concours ##{@contest.number}", @contest), title)
  end
  
  def title_contestproblem(contestproblem, title)
    return title_4((link_to "Concours", contests_path), (link_to "Concours ##{contestproblem.contest.number}", contestproblem.contest), (link_to "Problème ##{contestproblem.number}", contestproblem), title)
  end
  
  def x_icon
    return 'x-mid.svg' # 'X.gif'
  end
  
  def v_icon
    return 'check-lg.svg' # 'V.gif'
  end
  
  def dash_icon
    return 'dash-mid.svg' # 'tiret.gif'
  end
  
  def star_icon
    return 'star-fill-small.svg' # 'star1.png'
  end
  
  def warning_icon
    return 'exclamation-triangle.svg' # 'X.gif'
  end
  
  def blocked_icon
    return 'x-circle.svg'
  end
  
def ruby_to_javascript(arr)
  t = "["
  prems = true
  arr.each do |a|
    t << "," if !prems
    prems = false
    t << a.to_s
  end
  t << "]"
  return t.html_safe
end

def ruby_to_javascript_string(arr)
  t = "["
  prems = true
  arr.each do |a|
    t << "," if !prems
    prems = false
    t << "'" << a << "'"
  end
  t << "]"
  return t.html_safe
end

end
