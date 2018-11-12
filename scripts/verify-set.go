package main

import "fmt"
import "os/exec"
import "runtime"
import "strings"
import "sync"

func jqConfig(expression string) string {
	cmd := exec.Command(
		"jq",
		expression,
		"-r",
		"packages.json",
	)

	output, execErr := cmd.CombinedOutput()

	if execErr != nil {
		panic(execErr)
	}

	return string(output)
}

func getTargets() []string {
	output := jqConfig("keys[]")
	return strings.Fields(output)
}

func verifyDep(target string) {
	fmt.Println("Verifying ", target)
	cmd := exec.Command(
		"perl",
		"./scripts/verify-package.pl",
		target,
	)

	err := cmd.Run()

	if err != nil {
		fmt.Println("Failed to validate at target ", target)
		panic(err)
	}
}

func main() {
	targets := getTargets()

	runtime.GOMAXPROCS(10)

	var wg sync.WaitGroup
	wg.Add(len(targets))
	limit := make(chan struct{}, 5)

	for _, target := range targets {
		go func(target string) {
			limit <- struct{}{}
			defer func() {
			  <-limit
			}()
			defer wg.Done()
			verifyDep(target)
		}(target)
	}

	wg.Wait()
	fmt.Println("Finished")
}
