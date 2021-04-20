clear all
cd "C:\Users\Adrián Garrudo\Desktop\UPO\CUARTO\TFG\BASES DE DATOS"
use "EES_2018.dta"
compress
des 
sum

****Generamos las variables***

*SEXO
destring sexo, replace
replace sexo=0 if sexo==1
replace sexo=1 if sexo==6
gen hombre= sexo==0
gen mujer= sexo==1

*ESTUDIOS
destring estu, replace
gen noedu = estu==1
gen obligatoria= estu >= 2 & estu<=4 
gen fp = estu==5
gen superior= estu==6 & estu==7


*OCUPACION
gen ocu1 = cno1=="A0" 
gen ocu2 = cno1=="B0" | cno1=="C0"
gen ocu3 = cno1=="D0" 
gen ocu4 = cno1=="E0" | cno1=="F0"
gen ocu5 = cno1=="G0" | cno1=="H0" & cno1=="I0"
gen ocu6 = cno1=="J0" 
gen ocu7 = cno1=="K0" | cno1=="L0"
gen ocu8 = cno1=="M0" | cno1=="N0"
gen ocu9 = cno1=="P0" | cno1=="Q0" 
gen ocu10 = cno1=="O0"
*No meto servicio publico suponiendo que no hay discriminación
drop ocu10
*ACTIVIDAD ECONÓMICA

gen act1 = cnace == "B0"
gen act2 = cnace >= "C1" & cnace <= "C8"
gen act3 = cnace == "D0" | cnace == "E0"
gen act4 = cnace == "F0"
gen act5 = cnace == "G1" | cnace == "G2"
gen act6 = cnace == "H1" | cnace == "H2" | cnace == "J0"
gen act7 = cnace == "I0"
gen act8 = cnace == "K0"
gen act9 = cnace == "L0" | cnace == "M0"| cnace == "N0"
gen act10 = cnace == "P0"
gen act11 = cnace == "Q0"
gen act12 = cnace == "R0" | cnace == "S0"

*No meto  "O0" admin publica, defensa y Seg social


*EDAD
destring anos2,replace
gen joven = anos2<=02
gen adul = anos2==03 | anos2==04
gen viejo = anos2>=05

*ANTIGUEDAD
gen anti = anoanti
gen sqanti = anti^2

*TIPO DE CONTRATO
destring tipocon,replace
replace tipocon=0 if tipocon==1
replace tipocon=1 if tipocon==2
gen indef=tipocon==0
gen def=tipocon==1

*TIPO DE JORNADA
destring tipojor,replace
replace tipojor=0 if tipojor==1
replace tipojor=1 if tipojor==2
gen tcom = tipojor==0
gen tpar = tipojor==1

*NACIONALIDAD DEL MERCADO
destring mercado,replace
gen nac = mercado<=2
gen ue = mercado==3
gen mund = mercado==4

destring regulacion,replace
gen interprov = regulacion==1
gen prov = regulacion==2
gen regempres = regulacion==3 | regulacion==4

destring control, replace
replace control=0 if control==1
replace control=1 if control==2
gen publico = control==0
gen privado = control==1


destring responsa, replace
gen siresponsa= responsa==1
gen noresponsa= responsa==0

destring estrato2,replace
gen estra1 = estrato2==1
gen estra2 = estrato2==2
gen estra3 = estrato2==3

destring nuts1, replace


***DESCRIPTIVO ESTADISTICO***

mean salbase
mean salbase if hombre
mean salbase if mujer
tab mujer 
tab noedu sexo, col
tab obligatoria sexo, col
tab fp sexo, col
tab superior sexo, col
tabstat anti if mujer
tabstat anti if hombre

tab tcom sexo, col
tab tpar sexo, col

tab nac sexo, col
tab ue sexo, col
tab mund sexo, col

tab interprov sexo, col
tab prov sexo, col
tab regempres sexo, col


***********************SALARIO BUENO

gen diasrelaba=drelabam*30.42+drelabad
replace diasrelaba=365 if diasrelaba>365

gen diasano=diasrelaba-dsiespa2-dsiespa4

gen salanual=(365/diasano)*(retrinoin+retriin+vespnoin+vespin)
gen salmes=salanual/12
gen horas =((jsp1+(jsp2/60))*4.35)
gen salhora=(salmes)/horas
*drop if salhora>200
gen lsalhora=log(salhora)
lv salhora
lv salanual
drop salanual 


*** DESCRIPTIVO FACTORAL

tabstat salmes sexo noedu obligatoria fp superior anti sqanti indef tcom tpar privado interprov prov regempres nac ue mund ocu1-ocu9 act1-act12 estra1 estra2 estra3 siresponsa [aweight=factotal], by(sexo) stats(mean)

*REGRESIONES

global grupo1 sexo obligatoria fp anti sqanti indef tcom interprov prov regempres ue mund ocu2-ocu9 act2-act12 estra1 estra2 estra3 siresponsa i.nuts1
global grupo2 sexo obligatoria fp anti sqanti indef tcom interprov prov regempres ue mund estra1 estra2 estra3 siresponsa i.nuts1

reg lsalhora $grupo1 [aweight=factotal] 
reg lsalhora $grupo2 [aweight=factotal]





