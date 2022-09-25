package main

import (
	"fmt"
	"log"
	"net/url"

	"github.com/gorilla/schema"
)

type GetIngestsQueryParameters struct {
	// PerPage: Results per page (max 100).
	PerPage int32 `schema:"per_page,omitempty"`
	// Page: Page number of the results to fetch.
	Page    int32  `schema:"page,omitempty"`
	AssetId string `schema:"asset_id,omitempty"`
}

func main() {
	// To get query map from `r *http.Request`
	// use: r.URL.Query()
	m, err := url.ParseQuery(`per_page=30&page=3&asset_id=sb123`)
	if err != nil {
		log.Fatal(err)
	}

	qp := GetIngestsQueryParameters{}

	var decoder = schema.NewDecoder()

	err = decoder.Decode(&qp, m)
	if err != nil {
		panic(err)
	}

	fmt.Println("++++++++", qp)
}

