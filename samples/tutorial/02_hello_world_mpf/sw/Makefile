include ../../base/sw/base_include.mk

# Primary test name
TEST = cci_mpf_hello

# Build directory
OBJDIR = obj

# Files and folders
SRCS = $(TEST).cpp $(BASE_FILE_SRC)
OBJS = $(addprefix $(OBJDIR)/,$(patsubst %.cpp,%.o,$(SRCS)))

# Targets (build only $(TEST)_ase by default)
all: $(TEST)_ase

$(TEST): $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS) $(FPGA_LIBS)

$(TEST)_ase: $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS) $(ASE_LIBS)

$(OBJDIR)/%.o: %.cpp | objdir
	$(CXX) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TEST) $(TEST)_ase $(OBJDIR)

objdir:
	@mkdir -p $(OBJDIR)

.PHONY: all clean
