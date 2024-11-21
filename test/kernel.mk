TEST_KRNL = test/kernel.elf

# Dummy binary until a real test is written
$(TEST_KRNL):
	dd if=/dev/urandom of=$@ count=1 bs=1M 2> /dev/null

test-clean:
	rm -f $(TEST_KRNL)
