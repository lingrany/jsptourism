package com.tourism.model;

import java.math.BigDecimal;

public class Attraction {
    private int id;
    private String name;
    private BigDecimal ticketPrice;
    private String description;
    private String imagePath;
    private int cityId;

    public Attraction() {}

    public Attraction(int id, String name, BigDecimal ticketPrice, String description, String imagePath, int cityId) {
        this.id = id;
        this.name = name;
        this.ticketPrice = ticketPrice;
        this.description = description;
        this.imagePath = imagePath;
        this.cityId = cityId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(BigDecimal ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public int getCityId() {
        return cityId;
    }

    public void setCityId(int cityId) {
        this.cityId = cityId;
    }

    public boolean hasImage() {
        return imagePath != null && !imagePath.isEmpty();
    }
}
