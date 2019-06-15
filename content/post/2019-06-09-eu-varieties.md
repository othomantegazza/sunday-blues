---
title: "Who Submits Plant Varieties to the European Register?"
subtitle: "A sample of the European seed market"
summary: "If you want to market a plant variety as seeds or reproductive material, you must register that plant variety to certify that it is distinct, uniform and stable and that it has a potential value for cultivation. The European plant variety registration process has been criticized for favoring big companies, and thus, accentrating the seed market in few hands. I explored the European Register of Varieties to check which plant seed is allowed in the market and which company holds the rights."
author: "[Otho Mantegazza](https://otho.netlify.com)"
date: 2019-06-09
---

I'm venturing in unfamiliar territories, trying to explore the seed market in Europe (or more precisely, the market of Plant Reproductive and Propagation Material).

To make it easier and to help my readers to find inevitable (but hopefully few) mistakes, I'll document my research process. To write this article, I've downloaded data from Eurostat and from the Community Plant Variety Office (CPVO) and analyzed them. The R script that I've used to analyze those data are [available on Github](https://github.com/othomantegazza/sunday-blues/tree/master/content/post).

# The regulatory background

European laws decide and regulate which plant varieties are allowed in the European seed market.

Being a scientist, I don't have much experience in the field of law (or, not at all). In an effort to discover more about it, I have read and explored the [EU legislation](https://ec.europa.eu/food/plant/plant_propagation_material/legislation_en) framework on plant reproductive material. This is what I've found out...

The European regulation on [Plant reproductive material](https://www.euroseeds.eu/biodiversity-genetic-resources/plant-reproductive-material-seed-health) is complex. Is composed by at least 12 directives, that were written from 1966 until now (most are from the late '90 and the early '00). You can find those directives [on the website of the European Union](https://ec.europa.eu/food/plant/plant_propagation_material/legislation/review_eu_rules_en). Each directive regulates the marketing of different groups of plants, such as cereals, fodder plants, vegetables. Some directive regulates very heterogeneous groups, such as ornamental plants; others are very specifics, and regulate, for example, beet seeds, or potato seeds.   

This set of 12 directives is considered old. An Action Plan was established in 2009 to simplify them, update them, and unify them into one single document. A [draft regulation proposal](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:52013PC0262) was produced in 2013.

This proposal was discussed and then [withdrawed in 2014](https://www.euroseeds.eu/commission-withdraws-proposal-new-eu-seed-law), because the commission could see no agreement parliament and council: the proposal was deemed too controversial and thus abandoned. At least two position paper help to understand the position of the various interest groups. [One from the IFOAM](https://www.ifoam-eu.org/sites/default/files/page/files/ifoameu_policy_seed_position20130530_0.pdf), the main association of organic farmers, and [one from ESA](https://www.euroseeds.eu/esa130670-esa-position-paper-plant-reproductive-material), the main association of European Seed industries.

Comparing the two papers, you can see different positions and different framing of the issues of agriculture by the two groups. 

ESA pushes more for a simplified and uniform law, which stresses **traceability** of plant reproductive material, together with certification for **quality and reproducibility**, and **value for market**.

Instead, IFOAM reframes the farming issue as a problem of **agro-biodiversity** (or better, a lack of it), **sustainability** and **climate change**. They suggest that a strict regulation, will not allow to register highly diverse seed population, and it will not encourage seed exchange between farmers, and thus it will harm ecology and biodiversity. Moreover, they push for protection of traditional varieties.

I seem to understand that the last addition to the European seed is the [New Organic Seed Law](https://www.consilium.europa.eu/en/press/press-releases/2018/05/22/organic-farming-new-eu-rules-adopted/), that implements part of the requests by IFOAM on biodiversity and sustainability. This new law is discussed in a [recent position paper](https://www.ifoam-eu.org/sites/default/files/ifoam_eu_policy_seed_positionpaper_20190529.pdf). This law will apply from 1 January 2021.

I don't know enough to decide which of the two position (ESA vs IFOAM) will lay the basis for a more fair, diverse, sustainable and reliable agriculture. On paper both might work, if implemented in a functional social and economic environment. I would lean more toward the position by IFOAM, just because they suggest an approach to breeding and seed production which is radically different from what has been done in the last 70 years, and I feel that changes are much needed in Europe right now.

One thing stands clear though. If you want to market seeds of a plant variety in Europe, you have to register it.

# Main crops in Europe

Since each Plant Variety whose seeds are marketed in Europe must be registered, I decided to check who holds the rights for the varieties of main crops cultivated in Europe.

First I had to find out which are those main crops. Eurostat collects this information by Area. According to Eurostat, the main crops are: Wheat and Spelt, Barley, Maize, Rape and Turnip and Sunflower; and to a lesser extent: Olives, Oats, Rye, and Durum Wheat (the one used for pasta).

{{< figure src="/_plots/2019-05-26-main-crops.svg" >}}

In the plot above you can see how the area cultivated under the 10 main crops is distributed in European countries. To produce this plot I downloaded and analyzed data from Eurostat using [this script](https://github.com/othomantegazza/sunday-blues/blob/master/content/post/2019-05-26-eu-varieties-eurostat.R).

# Who registered most varieties

I wanted to see who registered varieties for those crops, to market their seeds.

For the top crops, I've selected:

- Wheat and Oat, as crop with highest acreage.
- Rapeseed as the main non-cereal crop.
- Durum wheat, to see if this highly regional crop is bred by the same actors as the others (durum wheat is cultivated mostly in Italy to produce pasta).

{{< figure src="/_plots/2019-05-26-registered-crops.svg" >}}

The donut plots above show how many varieties are registered and allowed in the market at this moment (2019, May 25th, when I downloaded the data) for the four crops mentioned above.

For each donut, I've shown separately the 5 breeders that registered most varieties at their name. While all the others are grouped under "others".

For each crop, only five breeders control more then half of the varieties in the market, and sometimes up to 75% of them. Limagrain, KWS, Syngenta and RAGT, control a big share of varieties for more than one crop.

Please, note that the donuts above show only the number of varieties controlled by each plant breeder. This might not reflect directly in their market share, because we don't know how many seeds are sold yearly for each variety. It might be that most of those hundreds of varieties have the same market share, or that only a couple of them dominate the market while most of the others are out of production. At this moment I don't have access to market data, if you know where I can access them, please contact me.

The data in the plot above come from the Community Plant Variety Office ([CPVO](https://europa.eu/european-union/about-eu/agencies/cpvo_en)). Unfortunately I had to download those data by hand from the search system. I could not find a way to get those data systematically, thus the analysis is not fully reproducible. Anyway you can find the scripts for the donut plots and the plot below [here on github](https://github.com/othomantegazza/sunday-blues/blob/master/content/post/2019-05-26-eu-varieties-donut.R).

Under the current legislation, it seems that most of plant varieties are controlled by few breeders.

# Bonus, wheat varieties in the market right now

Last, I wanted to check, how many varieties are licensed by public breeding initiative. I show this in detail for Wheat in the plot below. (Data are form the same dataset as above.)

{{< figure src="/_plots/2019-05-26-wheat-lite.svg" >}}

For every wheat variety that is registered and allowed in the market at this moment, the plot above shows, when it was registered and if the breeder that registered is private or public (public breeders are in violet). Most of current wheat varieties come from private breeder, and only few are from public breeders.


<!-- 
- What are the crops most used??
 
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
12. Rye
13. Durum wheat
-->

# Further reads

- The Greens - [Concentration of market power in the EU seed market](https://www.greens-efa.eu/en/article/document/concentration-of-market-power-in-the-eu-seed-market/)
- OECD - [Concentration in the seed market](https://www.oecd.org/publications/concentration-in-seed-markets-9789264308367-en.htm)
- EU - [seeds on the market - PDF](https://www.europarl.europa.eu/RegData/bibliotheque/briefing/2013/130547/LDM_BRI(2013)130547_REV1_EN.pdf)
- Public sector breeding in the era of privatization: [paper 1](https://www.researchgate.net/publication/23516896_Public_Sector_Plant_Breeding_In_A_Privatizing_World), [paper 2](https://www.researchgate.net/publication/42765146_Public_Plant_Breeding_in_an_Era_of_Privatisation)
