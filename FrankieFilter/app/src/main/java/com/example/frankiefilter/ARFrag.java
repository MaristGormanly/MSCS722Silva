package com.example.frankiefilter;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.Nullable;

import com.google.ar.core.Config;
import com.google.ar.core.Session;
import com.google.ar.sceneform.ux.ArFragment;

import java.util.EnumSet;
import java.util.Set;

public class ARFrag extends ArFragment{
    @Override
    protected Config getSessionConfiguration(Session session) {
        Config config = new Config(session);
        config.setAugmentedFaceMode(Config.AugmentedFaceMode.MESH3D);
        this.getArSceneView().setupSession(session);

        return config;
    }

    @Override
    protected Set<Session.Feature> getSessionFeatures() {
        // connecting to front facing camera
        return EnumSet.of(Session.Feature.FRONT_CAMERA);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        FrameLayout frameLayout = (FrameLayout) super.onCreateView(inflater, container, savedInstanceState);
        // dismisses android tutorial on how to detect planes
        getPlaneDiscoveryController().hide();
        getPlaneDiscoveryController().setInstructionView(null);

        return frameLayout;
    }
}
