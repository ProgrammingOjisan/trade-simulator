module ConditionsHelper
    def count_favorites(condition)
        condition.favorites.count
    end
    
    def set_duration_datalist(price_length)
	    duration_datalist = [["1年間",1],["2年間",2],["3年間",3],["5年間",5],["10年間",10],["20年間",20]]
        if price_length >= 245*20
			duration_datalist.slice(0..5)
        elsif price_length >= 245*10
			duration_datalist.slice(0..4)
		elsif price_length >= 245*5
    			duration_datalist.slice(0..3)
		elsif price_length >= 245*3
    			duration_datalist.slice(0..2)
		elsif price_length >= 245*2
    			duration_datalist.slice(0..1)
		elsif price_length >= 245
    			duration_datalist.slice(0)
    	else []
    	end
    end
    
end