package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
)

type build struct {
	Sha    string `json:"sha"`
	Status string `json:"status"` // either "failed" or "success"
}

func main() {
	// If we have a SHA override then use it.
	if os.Getenv("SHA") != "" {
		fmt.Println(os.Getenv("SHA"))
		os.Exit(0)
	}
	// If we have a TAG override then use it.
	if os.Getenv("TAG") != "" {
		fmt.Println(os.Getenv("TAG"))
		os.Exit(0)
	}

	resp, err := http.Get("https://gitlab.com/api/v4/projects/7508674/pipelines?ref=master&scope=finished&order_by=updated_at&sort=desc")
	if err != nil || resp.StatusCode > 299 {
		fmt.Println("Failed to fetch pipelines status.", err)
		os.Exit(1)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Failed to read GitLab's response.", err)
		os.Exit(1)
	}
	var builds []build
	err = json.Unmarshal(body, &builds)
	if err != nil {
		fmt.Println("Failed to parse pipelines status.", err)
		os.Exit(1)
	}
	// Get the first successful build. They are already sorted by update time,
	// so the first we find will be the most recent one.
	for _, b := range builds {
		if b.Status == "success" {
			fmt.Println(b.Sha)
			os.Exit(0)
		}
	}
	fmt.Println("No successful builds found.")
	os.Exit(1)
}
