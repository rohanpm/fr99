FREGE_JAR=frege.jar
FREGE_URL=https://github.com/Frege/frege/releases/download/3.22.324/frege3.22.524-gcc99d7e.jar
FREGE_CHECKSUM=8508f5b1f03beb69311a059e9a1684dfd0212ed1501fa96626f1e0b69363338a 

PROBLEMS=01

default:

clean:
	$(RM) -rf build

build:
	mkdir -p $@

build/fr99/%.class: $(FREGE_JAR) build
	java -Xss1m -jar $(FREGE_JAR) -d build $<

$(FREGE_JAR):
	curl -L -o $@.tmp "$(FREGE_URL)"
	echo '$(FREGE_CHECKSUM)  $@.tmp' | sha256sum --check
	mv $@.tmp $@

define PROBLEM_template =
 build/fr99/Pr$(1).class: src/pr$(1).fr $(FREGE_JAR) build
	java -Xss1m -jar $(FREGE_JAR) -d build $$<
 ALL_CLASSES   += build/fr99/Pr$(1).class
 ALL_MODULES   += fr99.Pr$(1)
endef

$(foreach pr,$(PROBLEMS),$(eval $(call PROBLEM_template,$(pr))))

default: $(ALL_CLASSES)

check: $(ALL_CLASSES)
	java -cp build:$(FREGE_JAR) frege.tools.Quick -v $(ALL_MODULES)
