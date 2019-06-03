---
title: "Who Submits Plants to the European Register of Variety?"
subtitle: "A sample of the european seed market"
summary: "If you want to market a plant variety as seeds or reproductive material, you must register that plant variety to certify that it is distinct, uniform and stable and that it has a potential value for coltvation. The European plant variety registration process has been criticized for favouring big companies, and thus, accentrating the seed market in few hands. I explored the European Register of Varieties to check which plant seed is allowed in the market and which company holds the rights."
author: "[Otho Mantegazza](https://otho.netlify.com)"
date: 2019-05-26
draft: true
---

I'm venturing in unfamiliar territories, trying to describe the seed market in Europe (or more precisely, the market of Plant Reproductive and Propagation Material).

To make it easier and to help my readers to find inevitable (but hopefully few) mistakes, I'll document my research process. To write this article, I've downloaded data from Eurostat and from the Community Plant Variety Office (CPVO) and analyzed them. The R script that I've used to analyze those data are [available on Github](https://github.com/othomantegazza/sunday-blues/tree/master/content/post).

# The regulatory background

European laws decide and regulate which plant varieties are allowed in the European seed market.

Being a scientist, I don't have much experience in the field of law (or, not at all). I tried to understand and summarize the [EU legislation](https://ec.europa.eu/food/plant/plant_propagation_material/legislation_en) framework on plant reproductive material. This is what I've found out...

The european regulation on [Plant reproductive material](https://www.euroseeds.eu/biodiversity-genetic-resources/plant-reproductive-material-seed-health) is complex. Is composed by at least 12 directives, that were written from 1966 until now (most are from the late '90 and the early '00). You can find those directives [on the website of the european union](https://ec.europa.eu/food/plant/plant_propagation_material/legislation/review_eu_rules_en). Each directive regulates the marketing of different groups of plants, such as cereals, fodder plants, vegetables. Some directive regulates very heterogeneous groups, such as hornamental plants; others are very specifics, and regulate, for example, beet seeds, or potato seeds.   

This set of 12 directives is considered old; an Action Plan was established in 2009 to simplify them and update them, and unify them into one single document. A [draft regulation proposal](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:52013PC0262) was produced in 2013.

This proposal was discussed and then [withdrawed in 2014](https://www.euroseeds.eu/commission-withdraws-proposal-new-eu-seed-law) because the commission could see no agreement parliament and council. The proposal was deemed too controversial and abandoned.

At least two position paper are very interesting reads that help to understand the position of the various interest groups. [One from the IFOAM](https://www.ifoam-eu.org/sites/default/files/page/files/ifoameu_policy_seed_position20130530_0.pdf), the main association of organic farmers, and [one from ESA](https://www.euroseeds.eu/esa130670-esa-position-paper-plant-reproductive-material), the main association of European Seed industries.

Also https://www.greens-efa.eu/en/article/document/concentration-of-market-power-in-the-eu-seed-market/


Not sure that this website is up to date. Was the review of 2013 stalled? I think so.

In 2018, new rules on organic farming published:
https://www.consilium.europa.eu/en/press/press-releases/2018/05/22/organic-farming-new-eu-rules-adopted/ . They apply from 1 jan 2021.

# Main crops in Europe

{{< figure src="/_plots/2019-05-26-main-crops.svg" >}}

# Who registered most varieties

{{< figure src="/_plots/2019-05-26-registered-crops.svg" >}}

# Bonus, wheat varieties in the market right now

{{< figure src="/_plots/2019-05-26-wheat-lite.svg" >}}


https://cpvoextranet.cpvo.europa.eu/mypvr/#!/en/publicsearch

- What are the crops most used? Wheat? Rice?
 
Eurostat

1. Cereals
3. Wheat/Spelt
2. Fodder
4. grazing
5. Barley
6. Maize (4802)
7. Rape
8. Olive
9. Oats
10. Sunflowers
11. Vineyards
12. Durum wheat

# Seeds on the market

https://www.europarl.europa.eu/RegData/bibliotheque/briefing/2013/130547/LDM_BRI(2013)130547_REV1_EN.pdf

Seeds on the market must be registered varieties. DUS: Distinct, Uniform, Stable. 

Plus. Value for Cultivation.

# Public breeding?
https://www.oecd.org/publications/concentration-in-seed-markets-9789264308367-en.htm

https://www.researchgate.net/publication/23516896_Public_Sector_Plant_Breeding_In_A_Privatizing_World

https://www.researchgate.net/publication/42765146_Public_Plant_Breeding_in_an_Era_of_Privatisation



- and fruit trees?


# position paper ifoam

https://www.ifoam-eu.org/sites/default/files/ifoam_eu_policy_seed_positionpaper_20190529.pdf