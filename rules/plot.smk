# SPDX-FileCopyrightText: 2023- The PyPSA-Eur Authors
#
# SPDX-License-Identifier: MIT


rule plot_power_network_unclustered:
    input:
        network=RESOURCES + "networks/elec.nc",
        rc="matplotlibrc",
    output:
        multiext(RESOURCES + "graphics/power-network-unclustered", ".png", ".pdf"),
    script:
        "../scripts/plot_power_network_unclustered.py"


rule plot_gas_network_unclustered:
    input:
        gas_network=RESOURCES + "gas_network.csv",
        gem=HTTP.remote(
            "https://globalenergymonitor.org/wp-content/uploads/2023/07/Europe-Gas-Tracker-2023-03-v3.xlsx",
            keep_local=True,
        ),
        entry="data/gas_network/scigrid-gas/data/IGGIELGN_BorderPoints.geojson",
        storage="data/gas_network/scigrid-gas/data/IGGIELGN_Storages.geojson",
        rc="matplotlibrc",
    output:
        multiext(RESOURCES + "graphics/gas-network-unclustered", ".png", ".pdf"),
    script:
        "../scripts/plot_gas_network_unclustered.py"


rule plot_power_network_clustered:
    input:
        network=RESOURCES + "networks/elec_s_{clusters}.nc",
        regions_onshore=RESOURCES + "regions_onshore_elec_s_{clusters}.geojson",
        rc="matplotlibrc",
    output:
        multiext(RESOURCES + "graphics/power-network-{clusters}", ".png", ".pdf"),
    script:
        "../scripts/plot_power_network_clustered.py"


rule plot_renewable_potential_unclustered:
    input:
        **{
            f"profile_{tech}": RESOURCES + f"profile_{tech}.nc"
            for tech in config["electricity"]["renewable_carriers"]
        },
        regions_onshore=RESOURCES + "regions_onshore.geojson",
        regions_offshore=RESOURCES + "regions_offshore.geojson",
        rc="matplotlibrc",
    output:
        wind=multiext(RESOURCES + "graphics/wind-energy-density", ".png", ".pdf"),
        solar=multiext(RESOURCES + "graphics/solar-energy-density", ".png", ".pdf"),
        wind_cf=multiext(RESOURCES + "graphics/wind-capacity-factor", ".png", ".pdf"),
        solar_cf=multiext(RESOURCES + "graphics/solar-capacity-factor", ".png", ".pdf"),
    script:
        "../scripts/plot_renewable_potential_unclustered.py"


rule plot_weather_data_map:
    input:
        cutout=f"cutouts/" + CDIR + config["atlite"]["default_cutout"] + ".nc",
        rc="matplotlibrc",
    output:
        irradiation=multiext(
            RESOURCES + "graphics/weather-map-irradiation", ".png", ".pdf"
        ),
        runoff=multiext(RESOURCES + "graphics/weather-map-runoff", ".png", ".pdf"),
        temperature=multiext(
            RESOURCES + "graphics/weather-map-temperature", ".png", ".pdf"
        ),
        wind=multiext(RESOURCES + "graphics/weather-map-wind", ".png", ".pdf"),
    script:
        "../scripts/plot_weather_data_map.py"


rule plot_industrial_sites:
    input:
        hotmaps="data/Industrial_Database.csv",
        countries=RESOURCES + "country_shapes.geojson",
        rc="matplotlibrc",
    output:
        multiext(RESOURCES + "graphics/industrial-sites", ".png", ".pdf"),
    script:
        "../scripts/plot_industrial_sites.py"


rule plot_powerplants:
    input:
        powerplants=RESOURCES + "powerplants.csv",
        rc="matplotlibrc",
    output:
        multiext(RESOURCES + "graphics/powerplants", ".png", ".pdf"),
    script:
        "../scripts/plot_powerplants.py"


rule plot_salt_caverns_unclustered:
    input:
        caverns="data/h2_salt_caverns_GWh_per_sqkm.geojson",
        rc="matplotlibrc",
    output:
        multiext(RESOURCES + "graphics/salt-caverns", ".png", ".pdf"),
    script:
        "../scripts/plot_salt_caverns_unclustered.py"


rule plot_salt_caverns_clustered:
    input:
        caverns=RESOURCES + "salt_cavern_potentials_s_{clusters}.csv",
        regions_onshore=RESOURCES + "regions_onshore_elec_s_{clusters}.geojson",
        regions_offshore=RESOURCES + "regions_offshore_elec_s_{clusters}.geojson",
        rc="matplotlibrc",
    output:
        onshore=multiext(
            RESOURCES + "graphics/salt-caverns-{clusters}-onshore", ".png", ".pdf"
        ),
        nearshore=multiext(
            RESOURCES + "graphics/salt-caverns-{clusters}-nearshore", ".png", ".pdf"
        ),
        offshore=multiext(
            RESOURCES + "graphics/salt-caverns-{clusters}-offshore", ".png", ".pdf"
        ),
    script:
        "../scripts/plot_salt_caverns_clustered.py"


rule plot_biomass_potentials:
    input:
        biomass=RESOURCES + "biomass_potentials_s_{clusters}.csv",
        regions_onshore=RESOURCES + "regions_onshore_elec_s_{clusters}.geojson",
        rc="matplotlibrc",
    output:
        solid_biomass=multiext(
            RESOURCES + "graphics/biomass-potentials-{clusters}-solid_biomass",
            ".png",
            ".pdf",
        ),
        not_included=multiext(
            RESOURCES + "graphics/biomass-potentials-{clusters}-not_included",
            ".png",
            ".pdf",
        ),
        biogas=multiext(
            RESOURCES + "graphics/biomass-potentials-{clusters}-biogas", ".png", ".pdf"
        ),
    script:
        "../scripts/plot_biomass_potentials.py"


rule plot_choropleth_capacity_factors:
    input:
        network=RESOURCES + "networks/elec_s{simpl}_{clusters}.nc",
        regions_onshore=RESOURCES + "regions_onshore_elec_s{simpl}_{clusters}.geojson",
        regions_offshore=RESOURCES + "regions_offshore_elec_s{simpl}_{clusters}.geojson",
        rc="matplotlibrc",
    output:
        directory(RESOURCES + "graphics/capacity-factor-s{simpl}-{clusters}"),
    script:
        "../scripts/plot_choropleth_capacity_factors.py"


rule plot_choropleth_capacity_factors_sector:
    input:
        cop_soil=RESOURCES + "cop_soil_total_elec_s{simpl}_{clusters}.nc",
        cop_air=RESOURCES + "cop_air_total_elec_s{simpl}_{clusters}.nc",
        regions_onshore=RESOURCES + "regions_onshore_elec_s{simpl}_{clusters}.geojson",
        rc="matplotlibrc",
    output:
        directory(RESOURCES + "graphics/capacity-factor-sector-s{simpl}-{clusters}"),
    script:
        "../scripts/plot_choropleth_capacity_factors_sector.py"


rule plot_balance_timeseries:
    input:
        network=RESULTS
        + "postnetworks/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}.nc",
        rc="matplotlibrc",
    threads: 12
    output:
        directory(RESULTS + "graphics/balance_timeseries/s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}")
    script:
        "../scripts/plot_balance_timeseries.py"


rule plot_heatmap_timeseries:
    input:
        network=RESULTS
        + "postnetworks/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}.nc",
        rc="matplotlibrc",
    threads: 12
    output:
        directory(RESULTS + "graphics/heatmap_timeseries/s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}")
    script:
        "../scripts/plot_heatmap_timeseries.py"

rule plot_heatmap_timeseries_resources:
    input:
        network=RESULTS
        + "prenetworks/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}.nc",
        rc="matplotlibrc",
    threads: 12
    output:
        directory(RESULTS + "graphics/heatmap_timeseries/s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}")
    script:
        "../scripts/plot_heatmap_timeseries_resources.py"


rule plot_power_network:
    params:
        plotting=config["plotting"],
    input:
        network=RESULTS
        + "postnetworks/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}.nc",
        regions=RESOURCES + "regions_onshore_elec_s{simpl}_{clusters}.geojson",
        rc="matplotlibrc",
    output:
        multiext(RESULTS
        + "maps/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}-costs-all_{planning_horizons}", ".png", ".pdf")
    threads: 2
    resources:
        mem_mb=10000,
    benchmark:
        (
            BENCHMARKS
            + "plot_network/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}"
        )
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/plot_power_network.py"

rule plot_hydrogen_network:
    params:
        foresight=config["foresight"],
        plotting=config["plotting"],
    input:
        network=RESULTS
        + "postnetworks/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}.nc",
        regions=RESOURCES + "regions_onshore_elec_s{simpl}_{clusters}.geojson",
        rc="matplotlibrc",
    output:
        multiext(RESULTS
        + "maps/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}-h2_network_{planning_horizons}", ".png", ".pdf")
    threads: 2
    resources:
        mem_mb=10000,
    benchmark:
        (
            BENCHMARKS
            + "plot_hydrogen_network/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}"
        )
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/plot_hydrogen_network.py"

rule plot_gas_network:
    params:
        plotting=config["plotting"],
    input:
        network=RESULTS
        + "postnetworks/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}.nc",
        regions=RESOURCES + "regions_onshore_elec_s{simpl}_{clusters}.geojson",
        rc="matplotlibrc",
    output:
        multiext(RESULTS
        + "maps/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}-ch4_network_{planning_horizons}", ".png", ".pdf")
    threads: 2
    resources:
        mem_mb=10000,
    benchmark:
        (
            BENCHMARKS
            + "plot_gas_network/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}"
        )
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/plot_gas_network.py"

rule plot_import_options:
    input:
        network=RESULTS
        + "prenetworks/elec_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}.nc",
        regions=RESOURCES + "regions_onshore_elec_s{simpl}_{clusters}.geojson",
        entrypoints=RESOURCES + "gas_input_locations_s{simpl}_{clusters}_simplified.csv",
        rc="matplotlibrc",
    output:
        multiext(RESULTS + "graphics/import_options_s{simpl}_{clusters}_l{ll}_{opts}_{sector_opts}_{planning_horizons}", ".png", ".pdf")
    script:
        "../scripts/plot_import_options.py"
